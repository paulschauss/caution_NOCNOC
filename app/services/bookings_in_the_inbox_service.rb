require 'uri'
require 'net/http'
require 'openssl'

class BookingsInTheInboxService

  def call
    ## Reset the Bookings and the Guests in the Database
    # PropertiesInfoListService.new.call
    # if Rails.env.development?
    #   Booking.destroy_all
    #   Guest.destroy_all
    # end

    set_url(10)
    set_json
    set_page_number
    add_bookings

    return "C'est fini !"
  end

  private

  def set_url(current_page_number)
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
      set_url(current_page_number + 1)
      set_json
      set_bookings
      create_bookings
    end
  end

  def set_bookings
    ap "je set les bookings"
    @api_bookings = @json["items"]
    return 'Bookings set'
  end

  def create_bookings
    ap "je crée les bookings"
    @api_bookings.each do |api_booking|
      ## set bookings fields
      @booking_lodgify_id = api_booking["id"]
      @property = Property.find_by(lodgify_id: api_booking["property_id"])
      @booking_arrival = api_booking["arrival"]
      @booking_departure = api_booking["departure"]
      @booking_language = api_booking["language"]
      @booking_status = api_booking["status"]

      ## set booking rooms
      # rooms = api_booking["rooms"]

      ## Set the Api-Guest
      api_guest = api_booking['guest']

      # Find or Create the Guest
      @guest = create_guest(api_guest)

      # Create the Booking
      @property.nil? ? next : create_booking
    end

    return "Creating done !"
  end

  def create_booking
    if Booking.find_by(lodgify_id: @booking_lodgify_id).nil?
      Booking.create!(
        lodgify_id: @booking_lodgify_id,
        guest: @guest,
        property: @property,
        arrival: @booking_arrival,
        departure: @booking_departure,
        language: @booking_language,
        status: @booking_status
      )
    end
  end

  def create_guest(api_guest)
    Guest.find_or_create_by!(
      name: api_guest['name'],
      email: api_guest['email'],
      phone: api_guest['phone']
    )
  end
end
