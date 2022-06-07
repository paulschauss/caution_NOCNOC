class MissingDepositService

  def initialize
    @missing_deposit_guest = []
  end

  def call
    Booking.all.each { |booking| check_deposit(booking) }
    return "missing deposit from #{missing_deposit_guest.join(", ")}"
  end

  private

  def check_deposit(booking)
    @missing_deposit_guest << booking.guest.name if booking.arrival == Date.today && booking.caution == "pending"
  end
end
