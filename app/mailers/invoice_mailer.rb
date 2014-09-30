class InvoiceMailer < ActionMailer::Base
  include Stripe::Callbacks

  default from: "BulldogClip <noreply@bulldogclip.co.uk>"

  after_invoice_payment_succeeded! do |invoice, event|
    # Rails.logger.info "InvoiceMailer: in the after invoice payment succeeded mailer"
    card = card_detail(invoice)
    account = Account.find_by_stripe_customer_token(invoice.customer)
    if account
      new_invoice(account, invoice, card).deliver
      update_account_next_invoice(account, invoice)
    else
      Rails.logger.error 'InvoiceMailer: invoice.payment_received did not trigger an email '
      error_invoice(invoice, event).deliver
    end
  end

  def new_invoice(account, invoice, card)
    @account = account
    @invoice = invoice
    @card = card
    mail :to => account.email, :subject => 'BulldogClip - Your new invoice'
    # add an attachment 
  end

  def error_invoice(invoice, event)
    @invoice = invoice
    @event = event
    mail to: 'info@bulldogclip.co.uk', subject: 'Invoice error'
  end

  def update_account_next_invoice(account, invoice)
    next_due = Stripe::Invoice.upcoming(customer: invoice.customer).date
    account.update(next_invoice: Time.at(next_due))
  rescue Stripe::InvalidRequestError
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
end
