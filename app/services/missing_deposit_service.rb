class MissingDepositService

  def initialize
    @missing_deposit_guests = []
  end

  def call
    check_missing_deposits()
    notifier = Slack::Notifier.new ENV.fetch("SLACK_WEBHOOK_URL"), channel: "app-nocnoc", username: 'notifier', icon_url: 'https://avatars0.githubusercontent.com/u/14098981?s=200&v=4'
    notifier.ping "Missing deposit from #{@missing_deposit_guests.join(", ")}" if @missing_deposit_guests.any?
    return "toto"
  end

  private

  def check_missing_deposits
    Booking.includes(:guest).where(arrival: Date.today).each do |booking|
      @missing_deposit_guests << booking.guest.name
    end
  end
end
