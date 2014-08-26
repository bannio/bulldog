class Account < ActiveRecord::Base
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

  before_update :process_changes
  after_create  :create_setting

  validates :name, :email, :plan_id, presence: true
  # validates :stripe_customer_token, presence: true, on: :create
  validates :email, uniqueness: true, format: {with: /\A[^@]+@[^@]+\z/}, on: :create
  validate :email_not_in_use, on: :create

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

  def personal?
    subscription_type == :personal
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

  def create_user
    self.save # to prevent triggering uniqueness check on user
    self.update(
      user_id: User.create(email: self.email).id
    )
  end

  def vat_allowed?
    vat_enabled? && business?
  end

  def process_subscription
    if get_customer
      process_sale
    else
      return false
    end
  end

  private
  def process_changes
    if plan_id_changed?
      if plan_id == 0  # cancellation
        result = process_cancellation
      else
        result = process_sale
      end
      Rails.logger.info "result is #{result}"
      return false unless result
    end
    if email_changed?
      change_email
    end
    # before_update is done. Other changes not involving plan_id,
    # like VAT enabled flag, fall through to here and get actioned
  end


  def process_sale
    sale = Sale.new(
      account_id:         self.id,
      plan_id:            self.plan_id,
      stripe_customer_id: self.stripe_customer_token,
      email:              self.email
    )
    sale.process!
    errors.add :base, sale.error if sale.errored?
    if sale.finished?
      self.card_last4 =       sale.card_last4
      self.card_expiration =  sale.card_expiration
      self.next_invoice =     get_next_invoice_date
    end
    sale.finished? ? true : false
  end

  def process_cancellation
    sale = Sale.new(
      account_id:         self.id,
      plan_id:            self.plan_id,
      stripe_customer_id: self.stripe_customer_token,
      email:              self.email
    )
    sale.cancel!
    errors.add :base, sale.error if sale.errored?
    if sale.finished?
      self.next_invoice = nil
    end
    sale.finished? ? true : false
  end

  def change_email
    customer = Stripe::Customer.retrieve(stripe_customer_token)
    customer.description = "Customer for #{email}"
    customer.email = email
    customer.save
  rescue Stripe::StripeError => e
    logger.error {"Stripe error while updating customer email: #{e.message}"}
    errors.add :base, "There was a problem updating email: #{e.message}"
    false
  end

  def get_customer
    # if valid? && stripe_card_token.present?
    if stripe_card_token.present?
      customer = Stripe::Customer.create(
        description: "Customer for #{email}",
        card:         stripe_card_token,
        email:        email 
        )
      self.stripe_customer_token = customer.id
    end
  rescue Stripe::InvalidRequestError, Stripe::CardError => e
    logger.error {"Stripe error while creating customer: #{e.message}"}
    errors.add :base, "There was a problem with your payment card: #{e.message}"
    false
  end

  def email_not_in_use
    errors.add(:email, "The email #{email.downcase} is already in use") unless 
      User.where(email: email.downcase).empty?
  end

  def get_next_invoice_date
    next_due = Stripe::Invoice.upcoming(customer: self.stripe_customer_token).date
    self.next_invoice = Time.at(next_due)
  rescue Stripe::InvalidRequestError
    self.next_invoice = nil
  end

end
