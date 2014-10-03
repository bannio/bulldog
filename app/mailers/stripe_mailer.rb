class StripeMailer < ActionMailer::Base

  default from: "BulldogClip <info@bulldogclip.co.uk>"

  def trial_period_ending(sub, account)
    @account = account
    @end_date = Time.at(sub.trial_end)
    mail to: @account.email, subject: "Your trial period is coming to an end"
  end
end