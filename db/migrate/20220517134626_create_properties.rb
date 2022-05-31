class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.integer :lodgify_id
      t.string :name
      t.string :zip
      t.string :city
      t.string :country
      t.string :address
      t.float :longitude
      t.float :latitude
      t.string :image_url

      t.timestamps
    end
  end
end
