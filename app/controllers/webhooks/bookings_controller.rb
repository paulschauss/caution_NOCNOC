class Webhooks::BookingsController < ActionController::Base
  def create
    json = params.to_json
    json_parsed = JSON.parse(json)
    booking = json_parsed["_json"][0]["booking"]
    ## make sure the property is in the database
    property_id = booking["property_id"]
    PropertyInfoByIdService.new(property_id).call

    ## update or create the booking
    booking_id = booking["id"]
    BookingByIdService.new(booking_id).call
  end
end
