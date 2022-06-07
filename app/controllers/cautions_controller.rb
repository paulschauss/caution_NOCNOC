class CautionsController < ApplicationController
  before_action :set_caution, only: %i[show update destroy]

  def index
    @cautions = Caution.all
  end

  def show
  end

  def new
    @caution = caution.new
  end

  def create
    @caution = caution.new(caution_params)
    if @caution.save
      redirect_to @caution, notice: "Caution was successfully created."
    else
      render :new, status: :unprocessable_entity
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
    @caution = caution.find(params[:id])
  end

  def caution_params
    params.require(:caution).permit(:name, :price, :price_cents, :currency)
  end
end
