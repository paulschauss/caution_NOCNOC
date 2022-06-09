require 'uri'
require 'net/http'
require 'openssl'

class PropertiesInfoListService

  def call
    # Property.destroy_all if Rails.env.development?
    set_url(10)
    set_json
    set_page_number
    add_properties
  end

  private

  def set_url(current_page_number)
    @url = URI("https://api.lodgify.com/v2/properties?includeCount=true&includeInOut=false&page=#{current_page_number}&size=50")
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
    @page_number.times do |current_page_number|
      set_url(current_page_number + 1)
      set_json
      set_properties
      create_properties
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
      property_address = api_property["address"]
      property_latitude = api_property["latitude"]
      property_longitude = api_property["longiproperty_longitude"]
      property_zip = api_property["zip"]
      property_city = api_property["city"]
      property_country = api_property["country"]
      property_image_url = get_image_url(api_property["image_url"])

      ## Create the property or find it if it already exists
      property = Property.find_by(lodgify_id: property_lodgify_id)
      if property.nil?
        Property.create!(
          lodgify_id: property_lodgify_id,
          name: property_name,
          latitude: property_latitude,
          longitude: property_longitude,
          zip: property_zip,
          city: property_city,
          country: property_country,
          image_url: property_image_url
        )
      else
        property.update!(
          name: property_name,
          latitude: property_latitude,
          longitude: property_longitude,
          zip: property_zip,
          city: property_city,
          country: property_country,
          image_url: property_image_url
        )
      end
    end
    ## Pour ne pas return @api_properties afin de ne pas encombrer le terminal
    return "Properties created"
  end

  def get_image_url(image_url)
    image_url.chars[2..-1].join
  end
end
