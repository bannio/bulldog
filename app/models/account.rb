class Account < ActiveRecord::Base

  include AASM

  belongs_to :user
  has_many :suppliers
  has_many :customers
  has_many :categories
  has_many :bills
  has_many :invoices
  has_many :vat_rates
  has_many :headers
  has_many :sales
  has_one  :setting
  belongs_to :plan

  after_create  :create_setting

  validates :name, :email, :plan_id, presence: true
  validates :email, uniqueness: true, format: {with: /\A[^@]+@[^@]+\z/}, on: :create

  # scope :owned_by_user, -> { where(user_id: current_user.id) }
  attr_accessor :stripe_card_token, :mail_list

  # Stripe Plans: 1: Personal annual, 2: Business monthly, 3: Business annual

  PLANS = { 1 => :personal, 2 => :business, 3 => :business }

  aasm column: 'state' do
    state :pending, initial: true
    state :trialing
    state :paying
    state :paid
    state :expired
    state :closed
    state :deleted

    event :sign_up do
      transitions from: :pending, to: :trialing
    end

    event :add_card do
      transitions from: :trialing, to: :paying
      transitions from: :expired, to: :paying
    end

    event :charge do
      transitions from: :paying, to: :paid
    end

    event :expire do
      transitions from: :trialing, to: :expired
    end

    event :close do
      transitions from: :paid, to: :closed
      transitions from: :trialing, to: :closed
    end

    event :restart do
      transitions from: :closed, to: :paid
    end

    event :delete do
      transitions from: :closed, to: :deleted
    end
  end

  def subscription_type
    PLANS[plan_id]
  end

  def business?
    subscription_type == :business
  end

  def personal?
    subscription_type == :personal
  end

  def active?
    # plan_id.present? && plan_id > 0
    trialing? || paid?
  end

  def self.owned_by_user(user)
    where(user_id: user.id)
  end

  def owner
    user
  end

  def customer(id)
    customers.find(id)
  end

  def supplier(id)
    suppliers.find(id)
  end

  def category(id)
    categories.find(id)
  end

  def bill(id)
    bills.find(id)
  end

  def invoice(id)
    invoices.find(id)
  end

  def vat_allowed?
    vat_enabled? && business?
  end

end
