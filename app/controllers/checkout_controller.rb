class CheckoutController < ApplicationController
  def create
    @checkout = Checkout.find(params[:id])
    @session = Stripe::PaymentIntent.create({
        payment_method_types: ['card'],
        line_items: [{
          name: caution.name,
          amount: caution.amount,
          currency: "eur",
          quantity: 1
        }],
        mode: 'payment',
        success_url: root_url,
        cancel_url: root_url,
      })
      respond do |format|
        format.js
      end
  end
end
