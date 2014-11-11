class UpdateAccount

  def self.call(*args)
    new(*args).call
  end

  def initialize(account)
    @account = account
  end

  def call
    ChangePlan.call(account) if plan_changed?
    CancelSubscription.call(account) if cancel?
    ChangeStripeEmail.call(account) if email_changed?
    account.save if account.errors.empty?
    account
  end

  private

  attr_reader :account
  def messages
    account.errors.full_messages
  end

  def plan_changed?
    account.plan_id_changed? && @account.plan_id > 0
  end

  def cancel?
    account.plan_id_changed? && @account.plan_id == 0
  end

  def email_changed?
    account.email_changed?
  end

end