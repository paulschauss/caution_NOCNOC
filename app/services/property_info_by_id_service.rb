require 'uri'
require 'net/http'
require 'openssl'

class PropertyInfoByIdService
  def initialize(property_id)
    @property_id = property_id
  end

  def call
    set_url
    set_property
    create_property
  end

  private

  def set_url
    @url = URI("https://api.lodgify.com/v1/properties/#{@property_id}")
  end

  def set_property
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    @api_property = JSON.parse(response.read_body)
  end

  def create_property
    zip = @api_property["zip"]
    city = @api_property["city"]
    country = @api_property["country"]

    @property = Property.find_by(lodgify_id: @property_id)
    @property.update(zip: zip, city: city, country: country)
  end

end
