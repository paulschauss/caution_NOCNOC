ap "welcome to the unusual seeds"

def count_good_deposit
  bookings_nil = Booking.all.filter { |booking| booking.deposit == 1000 }
  ap "#{bookings_nil.count} good deposit on #{Booking.count}"
end

def count_french
  frenchs = Booking.all.filter { |booking| booking.guest.country_code == "FR" || booking.guest.phone[0..1] == "06" || booking.guest.phone[0..1] == "07" }
  ap "#{frenchs.count} french on #{Booking.count}"
end

def display_phones
  Booking.all.each { |booking| ap booking.guest.phone }
end

count_good_deposit()

# display_phones()

count_french()
