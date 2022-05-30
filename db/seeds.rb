ap "welcome to the unusual seeds"

def good_deposit
  bookings_nil = Booking.all.filter { |booking| booking.deposit == 1000 }
  ap "#{bookings_nil.count} / #{Booking.count}"
end

def display_phones
  Booking.all.each { |booking| ap booking.guest.phone }
end

# good_deposit()

display_phones()
