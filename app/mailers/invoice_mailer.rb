class InvoiceMailer < ActionMailer::Base
  include Stripe::Callbacks

  default from: 'hello@bulldogclip.co.uk'

  after_invoice_created! do |invoice, event|
    Rails.logger.info "InvoiceMailer: in the after invoice created mailer"
    account = Account.find_by_stripe_customer_token(invoice.customer)
    user = account.owner
    new_invoice(user, invoice).deliver
  end

  def new_invoice(user, invoice)
    @user = user
    @invoice = invoice
    mail :to => user.email, :subject => 'BulldogClip - Your new invoice'
    # add an attachment 
  end
end