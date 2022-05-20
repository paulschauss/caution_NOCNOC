require 'uri'
require 'net/http'
require 'openssl'

class PropertiesInfoListService
  def call
    Property.destroy_all if Rails.env.development?
    set_url
    set_properties
    create_properties
  end

  private

  def set_url
    @url = URI("https://api.lodgify.com/v2/properties?includeCount=true&includeInOut=false&page=1&size=5000")
  end

  def set_properties
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV.fetch("LODGIFY_API_KEY") # ENV["LODGIFY_API_KEY"]

    response = http.request(request)
    @api_properties = JSON.parse(response.read_body)['items']
  end

  def create_properties
    @api_properties.each do |api_property|
      ## set property fields
      property_lodgify_id = api_property["id"]
      property_name = api_property["name"]
      property_latitude = api_property["latitude"]
      property_longitude = api_property["longitude"]
      rooms = api_property["rooms"]

      ## Creation de la property
      if Property.where(lodgify_id: property_lodgify_id).empty?
        property = Property.create!(lodgify_id: property_lodgify_id, name: property_name, latitude: property_latitude, longitude: property_longitude)
        ## add infos to property
        PropertyInfoByIdService.new(property_lodgify_id).call
      end

      ## set property rooms
      rooms.each do |room|
        room_lodgify_id = room["id"]
        room_name = room["name"]
        Room.create!(lodgify_id: room_lodgify_id, name: room_name, property: property)
      end
    end

    ## Pour ne pas return @api_properties afin de ne pas encombrer le terminal
    return "C'est fini"
  end
end
