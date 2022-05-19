class CreateGuests < ActiveRecord::Migration[6.1]
  def change
    create_table :guests do |t|
      t.string :lodgify_id
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
