class ContactBeforeEndService

  def initialize
    @client = Twilio::REST::Client.new(ENV.fetch('ACCOUNT_SID'), ENV.fetch('AUTH_TOKEN'))
  end

  def call
    Booking.all.each do |booking|
      if booking.departure == Date.tomorrow
        from_france?(booking) ? send_message_to_fr(booking) : send_message_to_en(booking)
      end
    end

    ## pour tester
    # booking = Booking.find_by(lodgify_id: 32279172)
    # send_message_to_fr(booking)

    return "Messages sended to clients"
  end

  private

  def from_france?(booking)
    booking.guest.phone[0..2] == "+33"
  end

  def send_message_to_fr(booking)
    ap "Send the message to #{booking.guest.name}, FRENCH version"
    message = @client.messages.create(
      from: ENV.fetch('TWILIO_NUMBER'),
      to: booking.guest.phone,
      body: "Bonjour #{booking.guest.name}, nous vous remercions de votre confiance et de votre séjour chez #{booking.property.name}. Nous vous souhaitons une bonne journée. A bientôt !"
    )
  end

  def send_message_to_en(booking)
    ap "Send the message to #{booking.guest.name} ENGLISH version"

  end

end
