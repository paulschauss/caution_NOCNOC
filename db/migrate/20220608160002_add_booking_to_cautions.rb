class AddBookingToCautions < ActiveRecord::Migration[6.1]
  def change
    add_reference :cautions, :booking, null: false, foreign_key: true
  end
end
