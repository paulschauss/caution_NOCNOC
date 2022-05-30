class ContactBeforeStartService
  def call
    Booking.all.each do |booking|
      if booking.arrival == Date.tomorrow
        from_france?(booking) ? send_mail_to_fr(booking) : send_mail_to_en(booking)
      end
    end
    return "Quote sended to clients"
  end

  private

  def from_france?(booking)
    booking.country_code.upcase == "FR" || booking.phone[0..1] == "06" || booking.phone[0..1] == "07" ? true : false
  end

  def send_mail_to_fr(booking)
    ap "Send the message to #{booking.guest.name}, english version"
  end

  def send_mail_to_en(booking)
    ap "Send the message to #{booking.guest.name} french version"
  end
end
