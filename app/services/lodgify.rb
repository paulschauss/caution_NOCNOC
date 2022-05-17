require 'uri'
require 'net/http'
require 'openssl'

class Lodgify
  def all_bookings_in_the_inbox
    url = URI("https://api.lodgify.com/v1/reservation")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
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

  def array_of_all_bookings_upcoming

    url = URI("https://api.lodgify.com/v2/reservations/bookings?page=1&size=50&includeCount=false&stayFilter=Upcoming&updatedSince=Date.now%20-%201&includeTransactions=false&includeExternal=false&includeQuoteDetails=false&trash=False")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    response.read_body
    booking = JSON.parse(response.read_body)['items'].first['damage_protection']
    ap booking
    # booking["items"].each do |item|
    #   ap booking.class
    # end
  end

  # def property_info_by_id(property_id)
  #   url = URI("https://api.lodgify.com/v1/properties/#{property_id}")

  #   http = Net::HTTP.new(url.host, url.port)
  #   http.use_ssl = true

  #   request = Net::HTTP::Get.new(url)
  #   request["Accept"] = 'text/plain'
  #   request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

  #   response = http.request(request)
  #   puts response.read_body[]
  # end
end
