class InvoiceMailer < ActionMailer::Base
  include Stripe::Callbacks

  default from: 'hello@bulldogclip.co.uk'

  after_invoice_payment_succeeded! do |invoice, event|
    Rails.logger.info "InvoiceMailer: in the after invoice payment succeeded mailer"
    charge = Stripe::Charge.retrieve(invoice.charge) rescue Stripe::InvalidRequestError
    account = Account.find_by_stripe_customer_token(invoice.customer)
    Rails.logger.info "CHARGE: #{charge}"
    if account && charge != Stripe::InvalidRequestError
      new_invoice(account, invoice, charge).deliver
    else
      Rails.logger.error 'InvoiceMailer: invoice.payment_received did not trigger an email '
      error_invoice(invoice, event).deliver
    end
  end

  def new_invoice(account, invoice, charge)
    @account = account
    @invoice = invoice
    @charge = charge
    mail :to => account.email, :subject => 'BulldogClip - Your new invoice'
    # add an attachment 
  end

  def error_invoice(invoice, event)
    @invoice = invoice
    @event = event
    # @error = error
    mail to: 'info@bulldogclip.co.uk', subject: 'Invoice error'
  end

end
