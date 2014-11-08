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

  # before_update :process_changes
  after_create  :create_setting

  validates :name, :email, :plan_id, presence: true
  # validates :stripe_customer_token, presence: true, on: :create
  validates :email, uniqueness: true, format: {with: /\A[^@]+@[^@]+\z/}, on: :create
  # validate :email_not_in_use, on: :create

  # scope :owned_by_user, -> { where(user_id: current_user.id) }
  attr_accessor :stripe_card_token, :mail_list

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

  def active?
    plan_id.present? && plan_id > 0
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

  # def create_user
  #   self.save # to prevent triggering uniqueness check on user
  #   self.update(
  #     user_id: User.create(email: self.email).id
  #   )
  # end

  def vat_allowed?
    vat_enabled? && business?
  end

  def process_subscription
    if create_stripe_customer
      process_sale
    else
      return false
    end
  end

  # def update_card(token)
  #   CardService.new({
  #     token:        token,
  #     customer_id:  self.stripe_customer_token,
  #     account:      self
  #   }).update_card
  #   # update_default_card
  # end

  def add_to_subscriber_list
    # only if there is a to address and the add to list box was checked
    return unless self.email.present? && self.mail_list == '1'
    grouping_id = ENV["MAILCHIMP_GROUP_TYPE_ID"]
    list_id = ENV["MAILCHIMP_MAIL_LIST"]
    merge_vars = {groupings: [id: grouping_id, groups: ["Users"]]}
    begin
      mailchimp.lists.subscribe(list_id, {'email' => email},merge_vars)
    rescue => e
      Rails.logger.error("MAILCHIMP lists.subscribe #{email} to list #{list_id} said: #{e}")
      # don't want to bother the user with success or failure here.
    end
  end

  private

  def process_sale
    ProcessSale.new(self).process
  end

  # def retrieve_stripe_customer
  #   customer = Stripe::Customer.retrieve(stripe_customer_token)
  # rescue Stripe::InvalidRequestError => e
  #   logger.error {"Stripe error while retrieving customer: #{e.message}"}
  #   errors.add :base, "#{e.message}"
  #   false
  # end

  def create_stripe_customer
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

  # def update_default_card
  #   if customer = retrieve_stripe_customer
  #     card = customer.cards.retrieve(customer.default_card)
  #     self.update(
  #       card_expiration:  Date.new(card.exp_year, card.exp_month, 1),
  #       card_last4:       card.last4
  #       )
  #   else
  #     false
  #   end
  # end

  # def email_not_in_use
  #   return false unless email
  #   errors.add(:email, "The email #{email.downcase} is already in use") unless
  #     User.where(email: email.downcase).empty?
  # end

  # def get_next_invoice_date
  #   next_due = Stripe::Invoice.upcoming(customer: self.stripe_customer_token).date
  #   self.next_invoice = Time.at(next_due)
  # rescue Stripe::InvalidRequestError
  #   self.next_invoice = nil
  # end

  # def mailchimp
  #   mailchimp ||= Mailchimp::API.new(ENV['MAILCHIMP-API-KEY'])
  # end
end
