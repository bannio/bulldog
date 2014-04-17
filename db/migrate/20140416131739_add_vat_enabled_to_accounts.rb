class AddVatEnabledToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :vat_enabled, :boolean
  end
end
