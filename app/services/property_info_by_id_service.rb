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
    set_rooms
  end

  def set_url
    @url = URI("https://api.lodgify.com/v2/properties/#{@property_id}?includeInOut=false")
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
    id = @api_property["id"]
    name = @api_property["name"]
    description = @api_property["description"]
    latitude = @api_property["latitude"]
    longitude = @api_property["longitude"]
    address = @api_property["address"]
    zip = @api_property["zip"]
    city = @api_property["city"]
    country = @api_property["country"]

    @property =  Property.new(id: id, name: name, description: description, latitude: latitude, longitude: longitude, address: address, zip: zip, city: city, country: country)

    ## pour plus tard histoire de ne pas encombrer la db
    # @property.save

  end

  def set_rooms
    @api_property["rooms"].each do |room|
      id = room["id"]
      name = room["name"]

      room = Room.new(id: id, name: name, property: @property)
      ap room

      ## pour plus tard histoire de ne pas encombrer la db
      # room.save

    end

    ## Pour ne pas return @api_property afin de ne pas encombrer le terminal
    return "C'est fini"
  end

end
