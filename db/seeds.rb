ap "welcome in the seeds"
bookings_nil = []
Booking.all.each do |booking|
  # ap booking.deposit
  bookings_nil << booking.lodgify_id if booking.deposit == 1000
end
ap "#{bookings_nil.count} / #{Booking.count}"
