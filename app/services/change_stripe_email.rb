class ChangeStripeEmail

  def self.call(account)
    # return false unless account.stripe_customer_token.present?
    email = account.email
    customer = RetrieveCustomer.call(account)
    customer.description = "Customer for #{email}"
    customer.email = email
    customer.save
    account
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    account
  end

end