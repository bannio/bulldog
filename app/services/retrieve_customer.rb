class RetrieveCustomer

  def self.call(account)
    Stripe::Customer.retrieve(account.stripe_customer_token)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end
end