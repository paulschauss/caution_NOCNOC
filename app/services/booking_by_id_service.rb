require 'uri'
require 'net/http'
require 'openssl'

class BookingByIdService
  def initialize(lodgify_id)
    @lodgify_id = lodgify_id
  end

  def call
    set_url
    set_json
    set_fields
  end

  private

  def set_url
    ap "set_url"
    @url = URI("https://api.lodgify.com/v2/reservations/bookings/#{@lodgify_id}")
  end

  def set_json
    ap "set_json"
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(@url)
    request["Accept"] = 'text/plain'
    request["X-ApiKey"] = ENV.fetch("LODGIFY_API_KEY")

    response = http.request(request)
    @api_booking = JSON.parse(response.read_body)
  end

  def set_fields
    ap "set_fields"

    @property = Property.find_by(lodgify_id: @api_booking["property_id"])

    @guest = create_guest(@api_booking['guest'])

    @booking_arrival = @api_booking["arrival"]
    @booking_departure = @api_booking["departure"]
    @booking_language = @api_booking["language"]
    @booking_status = @api_booking["status"]
    @booking_deposit = get_amount(@api_booking["quote"]["policy"]["name"]) unless @api_booking["quote"].nil?

    create_booking unless @property.nil?
  end

  def create_booking
    ap "create_booking"
    booking = Booking.find_by(lodgify_id: @lodgify_id)
    if booking.nil?
      booking = Booking.create!(
        lodgify_id: @lodgify_id,
        guest: @guest,
        property: @property,
        arrival: @booking_arrival,
        departure: @booking_departure,
        language: @booking_language,
        status: @booking_status,
        deposit: @booking_deposit
      )
      create_caution(booking)
    else
      booking.update!(
        guest: @guest,
        property: @property,
        arrival: @booking_arrival,
        departure: @booking_departure,
        language: @booking_language,
        status: @booking_status,
        deposit: @booking_deposit
      )
    end
  end

  def create_guest(api_guest)
    guest = Guest.find_or_create_by!(
      name: api_guest['name'],
      email: api_guest['email'],
      country_code: api_guest['country_code']
    )
    api_guest['phone'].nil? ? guest.update!(phone: "") : guest.update!(phone: remove_space(api_guest['phone']))
    return guest
  end

  def create_caution(booking)
    caution = Caution.find_or_create_by!(
      name: "Caution de #{booking.guest.name} booking_id n°#{booking.id}",
      amount: booking.deposit,
      booking: booking
    )
    return caution
  end

  def remove_space(phone)
    phone.chars.delete_if { |c| c == " " }.join
  end

  def get_amount(caution)
    result = caution.gsub(",", ".").split.filter { |word| Float(word[0..-2]).to_s.length >= 4 rescue false }.reject { |num| num.chars.include?(":") }.first.to_i
    result == 0 ? "#{1000}" : "#{result}"
  end
end
