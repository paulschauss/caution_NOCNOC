Rails.configuration.stripe = {
  publishable_key: Rails.env.production? ? ENV.fetch['STRIPE_PUBLIC_KEY'] : ENV.fetch('TEST_STRIPE_PUBLIC_KEY'),
  secret_key:      Rails.env.production? ? ENV.fetch['STRIPE_SECRET_KEY'] : ENV.fetch('TEST_STRIPE_SECRET_KEY')
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
