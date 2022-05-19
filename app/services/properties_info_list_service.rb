require 'uri'
require 'net/http'
require 'openssl'

class PropertiesInfoListService

  def call
    set_url
    set_properties
    create_properties

    ## pour tester sur une seule propriété
    # test_for_one_property
  end

  def set_url
    @url = URI("https://api.lodgify.com/v1/properties")
  end

  def set_properties
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    @api_properties = JSON.parse(response.read_body)
  end

  def create_properties
    @api_properties.each do |api_property|

      ## set property fields
      property_id = api_property["id"]
      property_name = api_property["name"]
      property_latitude = api_property["latitude"]
      property_longitude = api_property["longitude"]
      rooms = api_property["rooms"]

      ## Creation de la property
      if Property.where(id: property_id).empty?
        property = Property.create!(id: property_id, name: property_name, latitude: property_latitude, longitude: property_longitude)
      end

      ## set property rooms
      rooms.each do |room|
        room_id = room["id"]
        room_name = room["name"]
        Room.create!(id: room_id, name: room_name, property: property)
      end

      ## Pour plus tard histoire de ne pas encombrer la db
      # property.save
    end

    ## Pour ne pas return @api_properties afin de ne pas encombrer le terminal
    return "C'est fini"
  end

  ## pour tester sur une seule propriété
  def test_for_one_property
    first_property = @api_properties.first
    id = first_property["id"]
    name = first_property["name"]
    description = first_property["description"]
    latitude = first_property["latitude"]
    longitude = first_property["longitude"]
    address = first_property["address"]
    zip = first_property["zip"]
    city = first_property["city"]
    country = first_property["country"]
    ap Property.new(id: id, name: name, description: description, latitude: latitude, longitude: longitude, address: address, zip: zip, city: city, country: country)
  end
end
