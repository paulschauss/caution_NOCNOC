class MissingDepositService
  def call
    @missing_deposit_guests = missing_deposits
    notifier = Slack::Notifier.new ENV.fetch("SLACK_WEBHOOK_URL"), channel: "app-nocnoc",
                                                                   username: 'Coucou',
                                                                   icon_url: 'https://avatars0.githubusercontent.com
                                                                              /u/14098981?s=200&v=4'
    notifier.ping "Missing deposit from #{@missing_deposit_guests.join(', ')}" if @missing_deposit_guests.any?
  end

  private

  def missing_deposits
    Booking.includes(:guest).where(arrival: Date.today).reduce([]) { |acc, booking| acc << booking.guest.name }
  end
end
