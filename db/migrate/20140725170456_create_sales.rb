class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :plan, index: true
      t.references :account, index: true
      t.string :state
      t.string :stripe_charge_id
      t.string :stripe_customer_id
      t.string :card_last4
      t.date :card_expiration
      t.text :error
      t.integer :fee_amount
      t.string :email

      t.timestamps
    end
  end
end
