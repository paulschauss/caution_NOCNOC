require 'uri'
require 'net/http'
require 'openssl'

class ListOfBookingsService
  def call
    ## Reset the Bookings and the Guests in the Database
    PropertiesInfoListService.new.call
    # if Rails.env.development?
    #   Booking.destroy_all
    #   Guest.destroy_all
    # end

    url(10)
    set_json
    set_page_number
    add_bookings

    return "C'est fini !"
  end

  private

  def url(current_page_number)
    ap "je set l'url"
    @url = URI("https://api.lodgify.com/v2/reservations/bookings?page=#{current_page_number}&size=50&includeCount=true&includeTransactions=false&includeExternal=false&includeQuoteDetails=true")
  end

  def set_json
    ap "je set le json"

    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV.fetch("LODGIFY_API_KEY")

    response = http.request(request)
    @json = JSON.parse(response.read_body)
  end

  def set_page_number
    ap "je set le nombre de pages"
    count = @json["count"]
    @page_number = (count / 50) + 1
  end

  def add_bookings
    @page_number.times do |current_page_number|
      url(current_page_number + 1)
      set_json
      set_bookings
      create_bookings
    end
  end

  def set_bookings
    ap "je set l'api des bookings"
    @api_bookings = @json["items"]
    return 'Bookings set'
  end

  def create_bookings
    ap "je crée les bookings"
    @api_bookings.each do |api_booking|
      if api_booking["status"] == "Booked"
        ## set bookings fields
        @booking_lodgify_id = api_booking["id"]
        @property = Property.find_by(lodgify_id: api_booking["property_id"])
        @booking_arrival = api_booking["arrival"]
        @booking_departure = api_booking["departure"]
        @booking_language = api_booking["language"]
        @booking_status = api_booking["status"]
        @booking_deposit = get_amount(api_booking["quote"]["policy"]["name"]) unless api_booking["quote"].nil?

        ## set booking rooms
        # rooms = api_booking["rooms"]

        ## Set the Api-Guest
        api_guest = api_booking['guest']

        # Find or Create the Guest
        @guest = create_guest(api_guest)

        # Find or Create the Caution

        # Create the Booking
        @property.nil? ? next : create_booking
      end
    end

    return "Creating done !"
  end

  def create_booking
    booking = Booking.find_by(lodgify_id: @booking_lodgify_id)
    if booking.nil?
      booking = Booking.create!(
        lodgify_id: @booking_lodgify_id,
        guest: @guest,
        property: @property,
        arrival: @booking_arrival,
        departure: @booking_departure,
        language: @booking_language,
        status: @booking_status,
        deposit: @booking_deposit
      )
      create_caution(booking)
    else
      booking.update!(
        guest: @guest,
        property: @property,
        arrival: @booking_arrival,
        departure: @booking_departure,
        language: @booking_language,
        status: @booking_status,
        deposit: @booking_deposit
      )
    end
  end

  def create_guest(api_guest)
    guest = Guest.find_or_create_by!(
      name: api_guest['name'],
      email: api_guest['email'],
      country_code: api_guest['country_code']
    )
    api_guest['phone'].nil? ? guest.update!(phone: "") : guest.update!(phone: remove_space(api_guest['phone']))
    return guest
  end

  def create_caution(booking)
    caution = Caution.find_or_create_by!(
      name: "Caution de #{booking.guest.name} booking_id n°#{booking.id}",
      amount: booking.deposit,
      booking: booking
    )
    return caution
  end

  def remove_space(phone)
    phone.chars.delete_if { |c| c == " " }.join
  end

  def get_amount(caution)
    result = caution.gsub(",", ".").split.filter { |word| Float(word[0..-2]).to_s.length >= 4 rescue false }.reject { |num| num.chars.include?(":") }.first.to_i
    result == 0 ? "#{1000}" : "#{result}"
  end
end
