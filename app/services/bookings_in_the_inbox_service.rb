require 'uri'
require 'net/http'
require 'openssl'

class BookingsInTheInboxService

  def call
    if Rails.env.development?
      Booking.destroy_all
      Guest.destroy_all
    end
    set_url
    set_bookings
    create_bookings
    # test_method
  end

  private

  def set_url
    @url = URI("https://api.lodgify.com/v1/reservation?offset=0&limit=50&trash=false")
  end

  def set_bookings
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    @api_bookings = JSON.parse(response.read_body)['items']
  end

  def create_bookings
    @api_bookings.each do |api_booking|
      if Booking.where(lodgify_id: api_booking['id']).empty?

        ## Set the Guest
        api_guest = api_booking['guest']

        # Create the Guest
        guest = create_guest(api_guest)

        if Property.where(lodgify_id: api_booking['property_id']).any?

          ## Set the Property
          property = Property.find_by(lodgify_id: api_booking['property_id'])

          # Create the Booking
          Booking.create!(
            lodgify_id: api_booking['id'],
            property: property,
            guest: guest,
            arrival: api_booking['arrival'],
            departure: api_booking['departure']
          )

        else

          ap "Property doesn't exists"

        end
      end
    end

    return "C'est fini !"

  end

  def create_guest(api_guest)
    guest = Guest.create!(
      lodgify_id: api_guest['id'],
      name: api_guest['name'],
      email: api_guest['email'],
      phone: api_guest['phone'],
    )
    return guest
  end

  def test_method
    ap @api_bookings
  end
end
