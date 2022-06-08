class HoldController < ApplicationController

  def create
    @session = Stripe::PaymentIntent.create({
        payment_method_types: ['card'],
        line_items: [{
          name: caution.name,
          amount: caution.amount,
          currency: "eur",
          quantity: 1
        }],
        mode: 'payment',
        success_url: 'https://example.com/success',
        cancel_url: 'https://example.com/cancel'
      })
  end
end
