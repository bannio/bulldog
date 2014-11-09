class UpdateCard

  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    # @email = params[:email]
    # @plan_id = params[:plan_id]
    @token = params[:token]
    @account = params[:account]
  end

  def call
    # required params account, token
    customer = get_customer
    return false unless customer
    if update_stripe_customer_card(customer)
      new_card = stripe_customer_card(customer)
    else
      return false
    end
    update_account_card_details(new_card) if new_card
  end

  private

  attr_reader :token, :account #, :customer_id, :email, :plan_id


  def customer_id
    @customer_id ||= account.stripe_customer_token
  end

  def plan_attributes
    {
      plan: plan_id.to_s
    }
  end

  def get_customer
    # This will return a Stripe::Customer object
    Stripe::Customer.retrieve(customer_id)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
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
    account.add_card! unless account.paid?
  end

  def stripe_customer_card(customer)
    card = customer.cards.retrieve(customer.default_card)
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    false
  end
 end