class CancelSubscription

  def self.call(account)
    customer = RetrieveCustomer.call(account)
    sub_id = customer.subscriptions.first.id
    customer.subscriptions.retrieve(sub_id).delete
    account.close
    account
  rescue Stripe::StripeError => e
    account.errors[:base] << e
    account
  end
end