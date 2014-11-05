class CardService
  def initialize(params)
    @email = params[:email]
    @customer_id = params[:customer_id]
    @plan_id = params[:plan_id]
    @token = params[:token]
    @account = params[:account]
  end

  def create_customer
    # This will return a Stripe::Customer object
    external_customer_service.create(customer_attributes)
  rescue
    false
  end

  def get_customer
    # This will return a Stripe::Customer object
    external_customer_service.retrieve(get_customer_attributes)
  rescue
    false
  end

  def create_subscription
    # This will return a Stripe::Subscription object
    get_customer.subscriptions.create(plan_attributes)
  rescue #Stripe::StripeError => e
    # puts e.message
    false
  end

  def update_card
    update_customer_card
  end

  private

  attr_reader :email, :plan_id, :customer_id, :token, :account

  def external_customer_service
    Stripe::Customer
  end

  def customer_attributes
    {
      email: email
    }
  end

  def get_customer_attributes
    customer_id
  end

  def plan_attributes
    {
      plan: plan_id.to_s
    }
  end

  def card_attributes
    {
      account: account,
      token:   token
    }
  end

  def update_customer_card
    # Updates Stripe customer and uses returned customer object to
    # update account with card details.
    # This will return true or false
    # required params are token, customer_id, account
    customer = get_customer
    customer.card = token
    customer = customer.save
    card = customer.cards.retrieve(customer.default_card)
    account.update(
      card_expiration:  Date.new(card.exp_year, card.exp_month, 1),
      card_last4:       card.last4
    )
  rescue
    false
  end

end