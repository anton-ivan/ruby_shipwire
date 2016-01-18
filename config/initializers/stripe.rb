puts  ENV['STRIPE_PUBLISHABLE_KEY']
Rails.configuration.stripe = {
  :publishable_key => "pk_test_4Kq9PyD7AMr1v4rRqxDG73ws",
  :secret_key      => "sk_test_4Kq9IIswyBEcc9T0ThvsCOh6"
}

Stripe.api_key = "sk_test_4Kq9IIswyBEcc9T0ThvsCOh6"
