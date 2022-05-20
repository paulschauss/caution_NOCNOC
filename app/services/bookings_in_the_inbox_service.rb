require 'uri'
require 'net/http'
require 'openssl'

class BookingsInTheInboxService

  def call
    ## Reset the Bookings and the Guests in the Database
    if Rails.env.development?
      Booking.destroy_all
      Guest.destroy_all
    end

    ## Create the bookings for each property
    Property.all.each do |property|
      url = set_url(property)
      api_bookings = set_bookings(url)
      create_bookings(api_bookings, property)
    end
  end

  private

  def set_url(property)
    ap "je set l'url"
    return URI("https://api.lodgify.com/v1/reservation?offset=0&limit=50&status=Booked&trash=false&propertyId=#{property.lodgify_id}")
  end

  def set_bookings(url)
    ap "je set les bookings"

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    return JSON.parse(response.read_body)['items']
  end

  def create_bookings(api_bookings, property)
    ap "je crée les bookings"
    api_bookings.each do |api_booking|
      if Booking.where(lodgify_id: api_booking['id']).empty?

        ## Set the Api-Guest
        api_guest = api_booking['guest']

        # Find or Create the Guest
        guest = create_guest(api_guest)

        # Create the Booking
        Booking.create!(
          lodgify_id: api_booking['id'],
          property: property,
          guest: guest,
          arrival: api_booking['arrival'],
          departure: api_booking['departure']
        )
      end
    end

    return "C'est fini !"

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

    return guest

  end
end
