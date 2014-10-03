class ProcessStripeWebhooks
  include Stripe::Callbacks

  after_customer_subscription_trial_will_end! do |sub, event|
    account = Account.find_by_stripe_customer_token(sub.customer)
    if account
      StripeMailer.trial_period_ending(sub, account).deliver
    else
      Rails.logger.error "Trial ending - no account found for customer #{sub.customer}"
      # StripeMailer.admin_error(sub, event).deliver
    end
  end
end