class ProcessSale

  # attr_accessor :account

  def initialize(account)
    @account = account
  end

  def process
    puts "hello from sale"
    # sale = Sale.new(
    #   account_id:         account.id,
    #   plan_id:            account.plan_id,
    #   stripe_customer_id: account.stripe_customer_token,
    #   email:              account.email
    # )
    # sale.process!
    # account.errors.add :base, sale.error if sale.errored?
    # if sale.finished?
    #   account.card_last4 =       sale.card_last4
    #   account.card_expiration =  sale.card_expiration
    #   account.next_invoice =     get_next_invoice_date
    #   if plan_id == 1
    #     account.vat_enabled = false
    #   end
    # end
    # sale.finished? ? true : false
  end
end