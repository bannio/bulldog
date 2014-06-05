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
  after_create :add_setting

  validates :name, :email, :plan_id, presence: true
  validates :email, uniqueness: true, format: {with: /\A[^@]+@[^@]+\z/}
  # validates :user_id, presence: true, on: :create

  # scope :owned_by_user, -> { where(user_id: current_user.id) }
  attr_accessor :stripe_card_token

  def self.owned_by_user(user)
    where(user_id: user.id)
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

  private

  def add_setting
    create_setting
  end

end
