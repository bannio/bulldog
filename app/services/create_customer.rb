class CreateCustomer

  def self.call(account)
    begin
      # This will create a Stripe::Customer and
      # subscribe them to the plan. Note that this
      # must have a free trial as the customer has no card
      # The account is updated with stripe_customer_token
      # or with errors added
      customer = Stripe::Customer.create(
        email: account.email,
        description: "customer for #{account.email}",
        plan: account.plan_id
      )
      account.stripe_customer_token = customer.id
      trial_end = customer.subscriptions.data.first.trial_end
      account.trial_end = Time.at(trial_end)
    rescue Stripe::StripeError => e
      account.errors[:base] << e.message
      Rails.logger.info "Stripe error: #{e.message}"
      false
    end
    account
  end
end