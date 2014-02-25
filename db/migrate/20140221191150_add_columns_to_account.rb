class AddColumnsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :include_bank, :boolean
    add_column :accounts, :bank_account_name, :string
    add_column :accounts, :bank_name, :string
    add_column :accounts, :bank_address, :text
    add_column :accounts, :bank_account_no, :string
    add_column :accounts, :bank_bic, :string
    add_column :accounts, :bank_iban, :string
    add_column :accounts, :invoice_heading, :string
  end
end
