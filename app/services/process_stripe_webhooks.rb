class ProcessStripeWebhooks
  include Stripe::Callbacks

  after_customer_subscription_trial_will_end! do |sub, event|
    account = Account.find_by_stripe_customer_token(sub.customer)
    if account
      StripeMailer.trial_period_ending(sub, account).deliver
    else
      Rails.logger.error "Trial will end webhook - no account found for customer #{sub.customer}"
      # StripeMailer.admin_error(sub, event).deliver
    end
  end

  after_invoice_payment_succeeded! do |invoice, event|
    card = card_detail(invoice)
    status = subscription_status(invoice)
    account = Account.find_by_stripe_customer_token(invoice.customer)
    if account && status != 'trialing'
      StripeMailer.new_invoice(account, invoice, card).deliver
      update_account_next_invoice(account, invoice)
    else
      Rails.logger.error 'StripeWebhooks: invoice.payment_received did not trigger an email '
      StripeMailer.error_invoice(invoice, event).deliver
    end
  end

  def self.update_account_next_invoice(account, invoice)
    next_due = Stripe::Invoice.upcoming(customer: invoice.customer).date || false
    account.update(next_invoice: Time.at(next_due)) if next_due
  rescue Stripe::InvalidRequestError
    # do nothing if no date returned
  end

  def self.card_detail(invoice)
    if invoice.charge == "null"
      card = "NA"
    else
      begin
        charge = Stripe::Charge.retrieve(invoice.charge)
        card = "#{charge.card.type} ending in #{charge.card.last4}"
      rescue Stripe::InvalidRequestError
        card = "NA"
      end
    end
  end

  def self.subscription_status(invoice)
    customer = Stripe::Customer.retrieve(invoice.customer)
    status = customer.subscriptions.first.status
  rescue Stripe::InvalidRequestError
    status = "unknown"
  end
end