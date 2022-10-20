class PaymentIntentsController < ApplicationController
  def create
    payment_intents = Stripe::PaymentIntent.create(
      amount: 1000,
      currency: 'eur',
      description: 'Example payment intent',
      statement_descriptor: 'NOCNOC submit',
      payment_method_types: ['card']
    )

    render json: {
      id: payment_intents.id,
      client_secret: payment_intents.client_secret
    }
  end
end
