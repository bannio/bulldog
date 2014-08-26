class AddStripeColumnsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :card_last4, :integer
    add_column :accounts, :card_expiration, :date
    add_column :accounts, :next_invoice, :date
    add_column :accounts, :date_reminded, :date
  end
end
