class ChangePlan
  # expects account.plan_id to have been changed already
  def self.call(account)
    begin
      to_plan = account.plan_id
      customer = RetrieveCustomer.call(account)
      if customer.subscriptions.first
        sub_id = customer.subscriptions.first.id
        stripe_sub = customer.subscriptions.retrieve(sub_id)
        # trial_end date can be null.
        # use existing trial end if in the future
        # otherwise set to 'now' = special value to prevent
        # an extra free trial when changing plans
        if stripe_sub.trial_end.to_i > Time.now.to_i
          stripe_sub.trial_end = stripe_sub.trial_end.to_i
        else
          stripe_sub.trial_end = 'now'
        end
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