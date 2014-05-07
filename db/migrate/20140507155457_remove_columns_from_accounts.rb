class RemoveColumnsFromAccounts < ActiveRecord::Migration

  def up
    remove_column :accounts, :address
    remove_column :accounts, :postcode
    remove_column :accounts, :include_bank
    remove_column :accounts, :bank_account_name
    remove_column :accounts, :bank_name
    remove_column :accounts, :bank_address
    remove_column :accounts, :bank_account_no
    remove_column :accounts, :bank_bic
    remove_column :accounts, :bank_iban
    remove_column :accounts, :bank_sort
    remove_column :accounts, :invoice_heading
  end

  def down
    add_column :accounts, :address, :text
    add_column :accounts, :postcode, :text
    add_column :accounts, :include_bank, :boolean
    add_column :accounts, :bank_account_name, :string
    add_column :accounts, :bank_name, :string
    add_column :accounts, :bank_address, :text
    add_column :accounts, :bank_account_no, :string
    add_column :accounts, :bank_bic, :string
    add_column :accounts, :bank_iban, :string
    add_column :accounts, :bank_sort, :string
    add_column :accounts, :invoice_heading, :string
  end

end
