class PrecheckinsController < ApplicationController
  before_action :set_booking, only: %i[new create]

  def new
    @guest      = @booking.guest
    @property   = @booking.property
    @precheckin = Precheckin.new
  end

  def create
    @precheckin = Precheckin.new(precheckin_params)
    @precheckin.booking = @booking

    if @precheckin.save
      redirect_to booking_precheckin_path(@precheckin.booking, @precheckin)
    else
      flash[:alert] = 'Something went wrong'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @precheckin = Precheckin.find(params[:id])
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def precheckin_params
    params.require(:precheckin).permit(
      :first_name,
      :last_name,
      :email,
      :stripe_payment_id
    )
  end
end
