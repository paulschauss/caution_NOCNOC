require 'uri'
require 'net/http'
require 'openssl'
class PropertyInfoById
  def call(id)
    url = URI("https://api.lodgify.com/v1/properties/#{id}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = 'F47yidcmfdkYz4xCRDOX+QuQ7ruYWRHHWZyzbogicwqJsrBI8Gb4pQtCGBNZKpAx'

    response = http.request(request)
    puts response.read_body
  end
end
