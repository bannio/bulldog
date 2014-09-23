class UpdateAccount
  def initialize(account)
    @account = account
  end

  def update
    process_sale if sale?
    process_cancellation if cancel?
    change_stripe_customer_email if email_changed?
    save_account
  end

  def messages
    @account.errors.full_messages
  end

  private

  def sale?
    @account.plan_id_changed? && @account.plan_id != 0
  end

  def cancel?
    @account.plan_id_changed? && @account.plan_id == 0
  end

  def process_sale
    ProcessSale.new(@account).process
  end

  def process_cancellation
    CancelSale.new(@account).process
  end

  def change_stripe_customer_email
    ChangeStripeEmail.new(@account).change
  end

  def email_changed?
    @account.email_changed?
  end

  def save_account
    return false unless @account.errors.empty?
    @account.save
  end

end