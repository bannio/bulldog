class ChangePlan
  # expects account.plan_id to have been changed already
  def self.call(account)
    begin
      to_plan = account.plan_id
      customer = RetrieveCustomer.call(account)
      if customer.subscriptions.first
        sub_id = customer.subscriptions.first.id
        stripe_sub = customer.subscriptions.retrieve(sub_id)
        stripe_sub.plan = to_plan.to_s
        stripe_sub.save
      else
        customer.subscriptions.create(plan: to_plan)
      end
    rescue Stripe::StripeError => e
      account.errors[:base] << e.message
    end
    account.restart if account.closed?
    account
  end
end