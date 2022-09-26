class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @bookings_of_today = Booking.where("arrival = ?", Date.today)
  end
end
