require 'uri'
require 'net/http'
require 'openssl'

class BookingsInTheInboxService
  def initialize
    @current_page_number = 1
  end

  def call
    ## Reset the Bookings and the Guests in the Database
    # PropertiesInfoListService.new.call
    # if Rails.env.development?
    #   Booking.destroy_all
    #   Guest.destroy_all
    # end

    ## Create the bookings for each property
    set_url
    set_json
    set_page_number
    set_bookings
    add_bookings
    @current_page_number += 1
    return "C'est fini !"
  end

  private

  def set_url
    ap "je set l'url"
    @url = URI("https://api.lodgify.com/v2/reservations/bookings?page=#{@current_page_number}&size=50&includeCount=true&includeTransactions=false&includeExternal=false&includeQuoteDetails=true")
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

  def set_bookings
    ap "je set les bookings"
    @api_bookings = @json["items"]
    return 'Bookings set'
  end

  def add_bookings
    ap "je crée les bookings"
    @api_bookings.each do |api_booking|
       ## set bookings fields
      booking_lodgify_id = api_booking["id"]
      booking_guest_id = api_booking["user_id"]
      booking_property_id = api_booking["property_id"]
      booking_arrival = api_booking["arrival"]
      booking_departure = api_booking["departure"]
      booking_language = api_booking["language"]
      booking_status = api_booking["status"]

      booking_latitude = api_booking["latitude"]
      booking_longitude = api_booking["longitude"]
      ## set booking rooms
      rooms = api_booking["rooms"]

      if Booking.where(lodgify_id: booking_lodgify_id).empty?
        ## Set the Api-Guest
        api_guest = api_booking['guest']
        # Find or Create the Guest
        guest = create_guest(api_guest)
        # Create the Booking
        Booking.create!(
          lodgify_id: booking_lodgify_id,
          guest_id: booking_guest_id,
          property: booking_property_id,
          arrival: booking_arrival,
          departure: booking_departure,
          language: booking_language,
          status: booking_status
        )
      end
    end

    return "Creating done !"
  end

  def create_guest(api_guest)
    if Guest.where(lodgify_id: api_guest['id']).empty?
      guest = Guest.create!(
        lodgify_id: api_guest['id'],
        name: api_guest['name'],
        email: api_guest['email'],
        phone: api_guest['phone'],
      )
    else
      guest = Guest.find_by(lodgify_id: api_guest['id'])
    end
  end
end
