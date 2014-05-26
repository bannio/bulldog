class AddEmailToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :email, :string
    add_reference :accounts, :plan, index: true 
  end
end
