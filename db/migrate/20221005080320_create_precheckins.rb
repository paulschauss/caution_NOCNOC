class CreatePrecheckins < ActiveRecord::Migration[6.1]
  def change
    create_table :precheckins do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :language
      t.string :status
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
