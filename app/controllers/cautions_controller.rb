class CautionsController < ApplicationController
  before_action :set_caution, only: %i[show update destroy]

  def index
    @cautions = Caution.all
  end

  def show
  end

  def new
    @booking = Booking.find(params[:booking_id])
    @caution = Caution.new
  end

  def create
    @caution = Caution.new(caution_params)
    @booking = Booking.find(params[:booking_id])
    @caution.booking = @booking
    if @caution.save
      redirect_to booking_path(@booking), notice: "Caution was successfully created."
    else
      render :new
    end
  end

  def update
    if @caution.update(caution_params)
      redirect_to @caution, notice: "Caution was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @caution.destroy
    redirect_to cautions_url, notice: "Caution was successfully destroyed."
  end

  private

  def set_caution
    @caution = Caution.find(params[:id])
  end

  def caution_params
    params.require(:caution).permit(:name, :amount)
  end
end
