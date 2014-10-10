class CancelSale

  def initialize(account)
    @account = account
  end

  def process
    sale = Sale.new(
      account_id:         @account.id,
      plan_id:            @account.plan_id,
      stripe_customer_id: @account.stripe_customer_token,
      email:              @account.email
    )
    sale.cancel!
    @account.errors.add :base, sale.error if sale.errored?
    if sale.finished?
      @account.next_invoice = nil
      @account.plan_id = 0
    end
    sale.finished? ? true : false
  end
end