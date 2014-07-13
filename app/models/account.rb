class Account < ActiveRecord::Base
  belongs_to :user
  has_many :suppliers
  has_many :customers
  has_many :categories
  has_many :bills
  has_many :vat_rates
  has_many :headers
  has_one  :setting
  belongs_to :plan

  # accepts_nested_attributes_for :setting
  after_create :create_setting

  validates :name, :email, :plan_id, presence: true
  validates :email, uniqueness: true, format: {with: /\A[^@]+@[^@]+\z/}
  # validates :user_id, presence: true, on: :create

  # scope :owned_by_user, -> { where(user_id: current_user.id) }
  attr_accessor :stripe_card_token

  # Stripe Plans: 1: Personal annual, 2: Business monthly, 3: Business annual

  PLANS = { 1 => :personal, 2 => :business, 3 => :business }

  def subscription_type
    PLANS[plan_id]
  end

  def business?
    subscription_type == :business
  end

  def standard?
    subscription_type == :standard
  end

  def self.owned_by_user(user)
    where(user_id: user.id)
  end

  def owner
    user
  end

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      self.user = User.create(email: self.email)
      save!
    end
  rescue Stripe::InvalidRequestError, Stripe::CardError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your payment card: #{e.message}"
    false
  end

  def change_account_plan(new_plan_id)
    customer = Stripe::Customer.retrieve(stripe_customer_token)
    sub_id = customer.subscriptions.data.first.id  # return first subscription BUT there may be more!
    subscription = customer.subscriptions.retrieve(sub_id)
    subscription.plan = new_plan_id
    subscription.save
  end

  def vat_allowed?
    vat_enabled? && business?
  end

  private


end
