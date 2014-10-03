class StripeMailer < ActionMailer::Base

  default from: "BulldogClip <info@bulldogclip.co.uk>"

  def trial_period_ending(sub, account)
    @account = account
    @end_date = Time.at(sub.trial_end)
    mail to: @account.email, subject: "Your trial period is coming to an end"
  end

  def new_invoice(account, invoice, card)
    @account = account
    @invoice = invoice
    @card = card
    mail(to: account.email,
          subject: 'BulldogClip - Your new invoice',
          from: "BulldogClip <noreply@bulldogclip.co.uk>")
  end

  def error_invoice(invoice, event)
    @invoice = invoice
    @event = event
    mail to: 'info@bulldogclip.co.uk', subject: 'Invoice error'
  end
end