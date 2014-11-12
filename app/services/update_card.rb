class UpdateCard

  # takes account and a stripe token
  # returns account with or without errors

  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @token = params[:token]
    @account = params[:account]
  end

  def call
    customer = RetrieveCustomer.call(account) # Stripe customer object
    customer.card = token
    customer.save
    card = customer.cards.retrieve(customer.default_card) # Stripe card object
    if account.errors.empty? # no errors from RetrieveCustomer
      account.update(
        card_expiration:  Date.new(card.exp_year, card.exp_month, 1),
        card_last4:       card.last4
      )
      account.add_card! # change state handled by AASM
      account
    else
      account
    end
  rescue Stripe::StripeError => e
    account.errors[:base] << e.message
    Rails.logger.info "Stripe error: #{e.message}"
    Rails.logger.info "account errors: #{account.errors.full_messages}"
    account
  end

  private

  attr_reader :token, :account

 end