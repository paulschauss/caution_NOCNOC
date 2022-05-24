class ContactClientService
  def call
    Booking.all.each do |booking|
      if booking.departure == Date.tomorrow
        send_message(booking)
      end
    end
    return "Messages sended to clients"
  end

  private

  def send_message(booking)
    ap "Send the message to #{booking.guest.name}"
  end
end
