class InvoiceMailer < ActionMailer::Base
  include Stripe::Callbacks

  default from: 'hello@bulldogclip.co.uk'

  after_invoice_created! do |invoice, event|
    Rails.logger.info "InvoiceMailer: in the after invoice created mailer"
    account = Account.find_by_stripe_customer_token(invoice.customer)
    charge = Stripe::Charge.retrieve(invoice.charge)
    new_invoice(account, invoice, charge).deliver
  end

  def new_invoice(account, invoice, charge)
    @account = account
    @invoice = invoice
    @charge = charge
    mail :to => account.email, :subject => 'BulldogClip - Your new invoice'
    # add an attachment 
  end
end
