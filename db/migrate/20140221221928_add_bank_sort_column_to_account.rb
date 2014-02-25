class AddBankSortColumnToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :bank_sort, :string
  end
end
