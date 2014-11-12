
class ProcessSale

  # REPLACED by webhook event invoice.succeeded
  # def initialize(account)
  #   @account = account
  # end

  # def process
  #   sale = Sale.new(
  #     account_id:         @account.id,
  #     plan_id:            @account.plan_id,
  #     stripe_customer_id: @account.stripe_customer_token,
  #     email:              @account.email
  #   )
  #   sale.process!
  #   @account.errors.add :base, sale.error if sale.errored?
  #   if sale.finished?
  #     transfer_details_to_account(sale)
  #   end
  #   sale.finished? ? true : false
  # end

  # def transfer_details_to_account(sale)
  #   @account.card_last4 =       sale.card_last4
  #   @account.card_expiration =  sale.card_expiration
  #   @account.next_invoice =     sale.next_invoice
  #   if sale.plan_id == 1
  #     @account.vat_enabled = false
  #   end
  # end
end