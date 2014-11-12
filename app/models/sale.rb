class Sale < ActiveRecord::Base
  # include AASM
  belongs_to :plan
  belongs_to :account

  # any validations?

  # aasm column: 'state' do
  #   state :pending, initial: true
  #   state :processing
  #   state :finished
  #   state :errored

  #   event :process, after: :process_subscription do
  #     transitions from: :pending, to: :processing
  #   end

  #   event :cancel, after: :cancel_subscription do
  #     transitions from: :pending, to: :processing
  #   end

  #   event :finish do
  #     transitions from: :processing, to: :finished
  #   end

  #   event :fail do
  #     transitions from: :processing, to: :errored
  #   end
  # end

  # def process_subscription
  #   save!
  #   customer = Stripe::Customer.retrieve(self.stripe_customer_id)
  #   if customer.subscriptions.total_count == 0
  #     # create sub
  #     # Rails.logger.info"if part*******************"
  #     customer.subscriptions.create({plan: self.plan_id.to_s})
  #   else
  #     # update sub - currently expect to only ever have one subscription
  #     sub_id = customer.subscriptions.first.id
  #     subscription = customer.subscriptions.retrieve(sub_id)
  #     subscription.plan = self.plan_id.to_s
  #     subscription.save
  #     # Rails.logger.info"ELSE PART *******************"
  #   end
  #   card = customer.cards.retrieve(customer.default_card)
  #   self.update(
  #     card_last4:       card.last4,
  #     card_expiration:  Date.new(card.exp_year, card.exp_month, 1),
  #     next_invoice:     get_next_invoice_date
  #     )
  #   self.finish!
  # rescue Stripe::StripeError => e
  #   self.update_attributes(error: e.message)
  #   self.fail!
  # end

  # def cancel_subscription
  #   save!
  #   customer = Stripe::Customer.retrieve(self.stripe_customer_id)
  #   sub_id = customer.subscriptions.first.id
  #   customer.subscriptions.retrieve(sub_id).delete
  #   card = customer.cards.retrieve(customer.default_card)
  #   self.update(
  #     card_last4:       card.last4,
  #     card_expiration:  Date.new(card.exp_year, card.exp_month, 1)
  #     )
  #   self.finish!
  # rescue Stripe::StripeError => e
  #   self.update_attributes(error: e.message)
  #   self.fail!
  # end

  # def get_next_invoice_date
  #   next_due = Stripe::Invoice.upcoming(customer: self.stripe_customer_id).date
  #   self.next_invoice = Time.at(next_due)
  # rescue Stripe::InvalidRequestError
  #   self.next_invoice = nil
  # end
end
