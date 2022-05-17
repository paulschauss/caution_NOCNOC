require 'uri'
require 'net/http'
require 'openssl'

class PropertyInfoByIdService
  def initialize(property_id)
    @url = URI("https://api.lodgify.com/v1/properties/#{property_id}")
  end

  def call
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    result = JSON.parse(response.read_body)
    ap result
  end
end
