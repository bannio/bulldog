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
    status = subscription_status(invoice)
    account = Account.find_by_stripe_customer_token(invoice.customer)
    if account && status != 'trialing' # ignore first zero invoice
      card = card_detail(invoice) # returns a string not the card object!
      StripeMailer.new_invoice(account, invoice, card).deliver
      charge = Stripe::Charge.retrieve(invoice.charge)
      balance_txn = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)

      Sale.create(
        account_id:         account.id,
        plan_id:            account.plan_id,
        stripe_customer_id: invoice.customer,
        stripe_charge_id:   invoice.id,
        stripe_customer_id: invoice.customer,
        card_last4:         charge.card.last4,
        card_expiration:    Date.new(charge.card.exp_year, charge.card.exp_month, 1),
        fee_amount:         balance_txn.fee,
        invoice_total:      invoice.total
        )
      update_account_next_invoice(account, invoice)
    else
      Rails.logger.error 'StripeWebhooks: invoice.payment_received did not trigger an email '
      StripeMailer.error_invoice(invoice, event, status).deliver
    end
  end

  after_charge_succeeded! do |charge, event|
    account = Account.find_by_stripe_customer_token(charge.customer)
    account.charge!
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
    status = status + " amount_due #{invoice.amount_due}" if invoice.amount_due != 0
    status
  rescue Stripe::InvalidRequestError
    status = "unknown"
  end
end