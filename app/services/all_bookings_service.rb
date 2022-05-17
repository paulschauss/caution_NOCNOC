require 'uri'
require 'net/http'
require 'openssl'

class AllBookingsService

  def initialize
    @url = URI("https://api.lodgify.com/v1/reservation")
  end

  def call
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    booking = JSON.parse(response.read_body)['items']
    ap booking
    # if booking["arrival"] == Date.today - 1
    #   # start_date = booking["arrival"]
    #   # end_date = booking["departure"]
    #   # Booking.create!(start: )
    # end
  end
end
