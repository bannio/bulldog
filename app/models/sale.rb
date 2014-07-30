class Sale < ActiveRecord::Base
  include AASM
  belongs_to :plan
  belongs_to :account

  # any validations?

  aasm column: 'state' do
    state :pending, initial: true
    state :processing
    state :finished
    state :errored

    event :process, after: :process_subscription do
      transitions from: :pending, to: :processing
    end

    event :finish do
      transitions from: :processing, to: :finished
    end

    event :fail do
      transitions from: :processing, to: :errored
    end 
  end

  def process_subscription
    save!
    customer = Stripe::Customer.retrieve(self.stripe_customer_id)
    if customer.subscriptions.total_count == 0
      # create sub
      customer.subscriptions.create({plan: self.plan_id})
    else
      # update sub
      sub_id = customer.subscriptions.first.id
      subscription = customer.subscriptions.retrieve(sub_id)
      subscription.plan = self.plan_id
      subscription.save   
    end
   
    self.finish!
  rescue Stripe::StripeError => e
    self.update_attributes(error: e.message)
    self.fail!
  end
end
