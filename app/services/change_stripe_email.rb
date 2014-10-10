class ChangeStripeEmail

  def initialize(account)
    @account = account
  end

  def change
    return false unless @account.stripe_customer_token.present?
    customer = retrieve_stripe_customer
    change_email(customer, @account.email) if customer
  end

  private

  def retrieve_stripe_customer
    customer = Stripe::Customer.retrieve(@account.stripe_customer_token)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error {"Stripe error while retrieving customer: #{e.message}"}
    @account.errors.add :base, "#{e.message}"
    false
  end

  def change_email(customer, email)
    customer.description = "Customer for #{email}"
    customer.email = email
    customer.save
  end
end