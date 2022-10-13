class PrecheckinsController < ApplicationController
  def new
    @booking    = Booking.find(params[:booking_id])
    @guest      = @booking.guest
    @property   = @booking.property
    @precheckin = Precheckin.new
  end

  def create
    @precheckin = Precheckin.new(precheckin_params)

    if @precheckin.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @precheckin = Precheckin.find(params[:id])
  end

  private

  def precheckin_params
    params.require(:precheckin).permit(:first_name, :last_name, :email, :language, :status, :booking_id)
  end
end
