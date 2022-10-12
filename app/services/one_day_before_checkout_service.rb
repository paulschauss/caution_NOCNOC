class OneDayBeforeCheckoutService
  def initialize
    @client = Twilio::REST::Client.new(ENV.fetch('ACCOUNT_SID'), ENV.fetch('AUTH_TOKEN'))
  end

  def call
    Booking.includes(:guest).where(departure: Date.tomorrow).each do |booking|
      @booking = booking
      @guest = booking.guest
      @property = booking.property
      send_message
    end

    ## pour tester
    # @booking = Booking.find_by(lodgify_id: 32279172)
    # @guest = @booking.guest
    # @property = @booking.property
    # send_message()
  end

  private

  def from_france?
    @guest.phone[0..2] == "+33"
  end

  def send_message
    ap "Send the message to #{@guest.name}, #{from_france?() ? "FRENCH" : "ENGLISH"} version"
    # message = @client.messages.create(
    #   from: ENV.fetch('TWILIO_NUMBER'),
    #   to: @guest.phone,
    #   body: body()
    # )
  end

  def body
    if from_france?()
      "Bonjour #{@guest.name}, nous vous remercions de votre confiance et de votre séjour chez #{@property.name}. Nous vous souhaitons une bonne journée. A bientôt !"
    else
      "Hello #{@guest.name}, we are very pleased to have you at #{@property.name}. We hope you have a good day. See you soon !"
    end
  end


end
