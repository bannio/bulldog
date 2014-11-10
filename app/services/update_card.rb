class UpdateCard

  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @token = params[:token]
    @account = params[:account]
  end

  def call
    # required params account, token
    customer = RetrieveCustomer.call(account)
    return false unless customer
    if update_stripe_customer_card(customer)
      new_card = stripe_customer_card(customer)
    else
      return false
    end
    update_account_card_details(new_card) if new_card
  end

  private

  attr_reader :token, :account

  def update_stripe_customer_card(customer)
    customer.card = token
    customer.save
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end

  def update_account_card_details(card)
    account.update(
      card_expiration:  Date.new(card.exp_year, card.exp_month, 1),
      card_last4:       card.last4
    )
    account.add_card! # unless account.paid?
  end

  def stripe_customer_card(customer)
    card = customer.cards.retrieve(customer.default_card)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end
 end