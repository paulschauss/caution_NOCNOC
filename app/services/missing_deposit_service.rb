class MissingDepositService

  def initialize
    @missing_deposit_guest = []
  end

  def call
    Booking.all.each { |booking| check_deposit(booking) }
    notifier = Slack::Notifier.new(ENV.fetch("SLACK_WEBHOOK_URL")), username: 'notifier', icon_url: 'https://avatars0.githubusercontent.com/u/14098981?s=200&v=4'
    # notifier.ping "Missing deposit from #{@missing_deposit_guest.join(", ")}"
    return "done"
  end

  private

  def check_deposit(booking)
    @missing_deposit_guest << booking.guest.name if booking.arrival == Date.today
    # && booking.caution == "pending"
  end
end
