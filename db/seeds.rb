# ap "welcome to the unusual seeds"

# def count_fake_deposit
#   bookings_nil = Booking.all.filter { |booking| booking.deposit == 1000 }
#   ap "#{bookings_nil.count} fake deposit on #{Booking.count}"
# end

# def count_french
#   frenchs = Booking.all.filter { |booking| booking.guest.country_code == "FR" || booking.guest.phone[0..1] == "06" || booking.guest.phone[0..1] == "07" }
#   ap "#{frenchs.count} french on #{Booking.count}"
# end

# def display_phones
#   Booking.all.each { |booking| ap booking.guest.phone }
# end

# count_fake_deposit()

# count_french()

# display_phones()
prop = Property.find_by(lodgify_id: 32279172)
prop.destroy unless prop.nil?
prop = Property.create!(
  lodgify_id: 32279172,
  name: "Ma belle maison",
  address: "41 avenue lamartine",
  zip: "69100",
  city: "Lyon",
  country: "France",
)
ap "#{prop.name} created"

ben = Guest.find_by(name: "Benjamin Boisson")
ben.destroy unless ben.nil?
ben = Guest.create!(
  name: "Benjamin Boisson",
  email: "benjbdk@gmail.com",
  phone: "+33613653334"
)
ap "#{ben.name} created"

book = Booking.find_by(lodgify_id: 32279172)
book.destroy unless book.nil?
Booking.create!(
  lodgify_id: 32279172,
  guest: ben,
  property: prop,
  arrival: Date.today,
  departure: Date.today + 1,
  status: "available",
  language: "fr",
  deposit: 1000
)

ap "and the booking created"
