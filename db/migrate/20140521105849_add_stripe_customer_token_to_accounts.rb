class AddStripeCustomerTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_customer_token, :string
  end
end
