require 'uri'
require 'net/http'
require 'openssl'

class PropertiesInfoListService
  def initialize
    @current_page_number = 1
  end

  def call
    # Property.destroy_all if Rails.env.development?
    set_url
    set_json
    set_page_number
    add_properties
  end

  private

  def set_url
    @url = URI("https://api.lodgify.com/v2/properties?includeCount=true&includeInOut=false&page=#{@current_page_number}&size=50")
  end

  def set_json
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV.fetch("LODGIFY_API_KEY")

    response = http.request(request)
    @json = JSON.parse(response.read_body)
  end

  def set_page_number
    count = @json["count"]
    @page_number = (count / 50) + 1
  end

  def add_properties
    @page_number.times do
      set_url
      set_json
      set_properties
      create_properties
      @current_page_number += 1
    end
    return "C'est fini"
  end

  def set_properties
    @api_properties = @json["items"]
  end

  def create_properties
    @api_properties.each do |api_property|
      ## set property fields
      property_lodgify_id = api_property["id"]
      property_name = api_property["name"]
      property_latitude = api_property["latitude"]
      property_longitude = api_property["longitude"]
      ## set property rooms
      rooms = api_property["rooms"]

      ## Creation de la property
      if Property.where(lodgify_id: property_lodgify_id).empty?
        property = Property.create!(
                          lodgify_id: property_lodgify_id,
                          name: property_name,
                          latitude: property_latitude,
                          longitude: property_longitude
                        )
        ## add infos to property
        PropertyInfoByIdService.new(property_lodgify_id).call
      else
        property = Property.find_by(lodgify_id: property_lodgify_id)
      end

      ## create property rooms
      create_rooms(rooms, property)
    end

    ## Pour ne pas return @api_properties afin de ne pas encombrer le terminal
    return "Properties created"
  end

  def create_rooms(rooms, property)
    rooms.each do |room|
      room_lodgify_id = room["id"]
      room_name = room["name"]
      if Room.where(lodgify_id: room_lodgify_id).empty?
        Room.create!(lodgify_id: room_lodgify_id, name: room_name, property: property)
      end
    end
  end
end
