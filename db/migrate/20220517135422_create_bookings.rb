class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.integer :lodgify_id
      t.references :guest, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.date :arrival
      t.date :departure
      t.string :language
      t.string :status

      t.timestamps
    end
  end
end
