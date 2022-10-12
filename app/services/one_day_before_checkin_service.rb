class OneDayBeforeCheckinService
  def initialize
    @base_url = "https://nocnoc-staging.herokuapp.com/cautions"
    @client = Twilio::REST::Client.new(ENV.fetch('ACCOUNT_SID'), ENV.fetch('AUTH_TOKEN'))
  end

  def call
    Booking.includes(:guest, :property).where(arrival: Date.tomorrow).each do |booking|
      @booking = booking
      @guest = booking.guest
      @property = booking.property
      send_message()
    end

    # pour tester
    # @booking = Booking.find_by(lodgify_id: 32279172)
    # @guest = @booking.guest
    # @property = @booking.property
    # send_message()
  end

  private

  def send_message
    ap "Send the message to #{@guest.name}, #{from_france?() ? 'FRENCH' : 'ENGLISH'} version"
    # message = @client.messages.create(
    #   from: ENV.fetch('TWILIO_NUMBER'),
    #   to: @guest.phone,
    #   body: body()
    # )
  end

  # def send_mail
  #   ap "Send the mail to #{@guest.name}, #{from_france?() ? "FRENCH" : "ENGLISH"} version"
  # end

  def body
    if from_france?()
      "Bonjour #{@guest.name}, vous arrivez demain dans l'appartement '#{@property.name}' à #{@property.city}.
      Avant votre arrivée merci de bien remplir le formulaire à l'adresse ci-contre #{@base_url}/#{@booking.caution.id}"
    else
      "Hello #{@guest.name}, you are about to arrive in the apartment '#{@property.name}' in #{@property.city}. Before
      your arrival, please fill out the form at the address below #{@base_url}/#{@booking.caution.id}"
    end
  end

  def from_france?
    @guest.phone[0..2] == "+33"
  end
end
