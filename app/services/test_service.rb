class TestService

  def call
    json = {"_json"=>[{"action"=>"aap_booking_new", "booking"=>{"type"=>"Booking", "id"=>4621366, "date_arrival"=>"2022-06-13T00:00:00", "date_departure"=>"2022-06-14T00:00:00", "date_created"=>"2022-06-09T13:53:20+00:00", "property_id"=>286364, "property_name"=>"NOCNOC L'Artiste - Bel appartement au pied du Capitole", "property_image_url"=>"https://l.icdbcdn.com/oh/c4ed9e67-413a-4715-832a-4bc2c16130d3.jpg?f=32", "status"=>"Booked", "room_types"=>[{"id"=>4752212, "room_type_id"=>350378, "image_url"=>nil, "name"=>"", "people"=>2}], "add_ons"=>[], "currency_code"=>"EUR", "source"=>"BookingCom", "source_text"=>"2225487141|3689798459", "notes"=>nil, "language"=>"fr", "ip_address"=>nil, "ip_country"=>nil, "is_policy_active"=>false, "external_url"=>"https://admin.booking.com/hotel/hoteladmin/extranet_ng/manage/booking.html?hotel_id=6219921&res_id=2225487141", "nights"=>1, "promotion_code"=>nil}, "guest"=>{"uid"=>"ZqvaLg6pJEeZ2mzPOVLvGQ", "name"=>"Pascal Cézard", "email"=>"pcezar.100090@guest.booking.com", "phone_number"=>"+33 7 82 38 94 74", "country"=>nil, "country_code"=>nil}, "current_order"=>{"id"=>2776669, "property_id"=>286364, "currency_code"=>"EUR", "status"=>"NotScheduled", "amount_gross"=>{"amount"=>"260.51", "total_room_rate_amount"=>"193.75", "total_fees_amount"=>"66.76", "total_taxes_amount"=>"0", "total_promotions_amount"=>"0"}, "amount_net"=>{"amount"=>"260.51", "total_room_rate_amount"=>"193.75", "total_fees_amount"=>"66.76", "total_taxes_amount"=>"0", "total_promotions_amount"=>"0"}, "date_agreed"=>nil, "cancellation_policy_text"=>"", "security_deposit_text"=>"", "scheduled_policy_text"=>"Non prévu par Lodgify", "rate_policy_name"=>"N/A", "rental_agreement_accepted"=>false, "owner_payout"=>0.0}, "subowner"=>{"user_id"=>283134, "first_name"=>"Diane", "last_name"=>"Saadi-Sarrault", "email"=>"toulouse@nocnoc.fr", "phone"=>"769668115"}, "booking_total_amount"=>"260.51", "booking_currency_code"=>"EUR", "total_transactions"=>{"amount"=>"0"}, "balance_due"=>"260.51"}], "booking"=>{}}.to_json
    json_parsed = JSON.parse(json)

    booking = json_parsed["_json"][0]["booking"]
    ## make sure the property is in the database
    ap property_id = booking["property_id"]
    # PropertyInfoByIdService.new(property_id).call

    ## update or create the booking
    ap booking_id = booking["id"]
    # BookingByIdService.new(booking_id).call
  end
end
