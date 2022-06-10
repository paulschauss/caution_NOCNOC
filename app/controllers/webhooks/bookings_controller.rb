class Webhooks::BookingsController < ActionController::Base
  skip_before_filter :verify_authenticity_token, only: %i[create]

  def create
    json = params.to_json
    json_parsed = JSON.parse(json)
    booking_id = json_parsed["_json"][0]["booking"]["id"]
    BookingByIdService.new(booking_id).call
  end
end
