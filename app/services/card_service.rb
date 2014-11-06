class CardService
  def initialize(params)
    @email = params[:email]
    # @customer_id = params[:customer_id]
    @plan_id = params[:plan_id]
    @token = params[:token]
    @account = params[:account]
  end

  def create_customer
    # This will return a Stripe::Customer object
    Stripe::Customer.create(customer_attributes)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end

  def get_customer
    # This will return a Stripe::Customer object
    Stripe::Customer.retrieve(customer_id)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end

  def create_subscription
    # This will return a Stripe::Subscription object
    customer = get_customer
    return false unless customer
    customer.subscriptions.create(plan_attributes)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end

  def update_card
    # required params account, token
    customer = get_customer
    return false unless customer
    if update_stripe_customer_card(customer)
    # retrieve updated card
      card = stripe_customer_card(customer)
    else
      return false
    end
    update_account_card_details(card) if card
  end

  private

  attr_reader :email, :plan_id, :token, :account #, :customer_id

  def customer_attributes
    {
      email: email,
      account: account
    }
  end

  def customer_id
    customer_id ||= account.stripe_customer_token
  end

  def plan_attributes
    {
      plan: plan_id.to_s,
      account: account
    }
  end

  def card_attributes
    {
      account: account,
      token:   token
    }
  end

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
  end

  def stripe_customer_card(customer)
    card = customer.cards.retrieve(customer.default_card)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end
 end