class InvoiceMailer < ActionMailer::Base
  include Stripe::Callbacks

  default from: 'hello@bulldogclip.co.uk'

  after_invoice_payment_succeeded! do |invoice, event|
    Rails.logger.info "InvoiceMailer: in the after invoice payment succeeded mailer"
    if account = Account.find_by_stripe_customer_token(invoice.customer)
      begin
        charge = Stripe::Charge.retrieve(invoice.charge)
        new_invoice(account, invoice, charge).deliver
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error e.message
        error_invoice(invoice, event, e).deliver
      end
    end
  end

  def new_invoice(account, invoice, charge)
    @account = account
    @invoice = invoice
    @charge = charge
    mail :to => account.email, :subject => 'BulldogClip - Your new invoice'
    # add an attachment 
  end

  def error_invoice(invoice, event, error)
    @invoice = invoice
    @event = event
    @error = error
  end

end
