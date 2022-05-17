class CreateGuests < ActiveRecord::Migration[6.1]
  def change
    create_table :guests do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :country_code

      t.timestamps
    end
  end
end
