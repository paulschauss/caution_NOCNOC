require 'uri'
require 'net/http'
require 'openssl'

class BookingsInTheInboxService

  def call
    set_url
    set_bookings
  end

  def set_url
    @url = URI("https://api.lodgify.com/v1/reservation")
  end

  def set_bookings
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    @bookings = JSON.parse(response.read_body)['items']
    ap @booking
  end
end
