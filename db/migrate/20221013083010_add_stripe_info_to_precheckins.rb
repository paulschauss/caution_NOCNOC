class AddStripeInfoToPrecheckins < ActiveRecord::Migration[6.1]
  def change
    add_column :precheckins, :stripe_payment_id, :string
  end
end
