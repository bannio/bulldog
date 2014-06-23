class RenameDefaultColumnInCustomers < ActiveRecord::Migration
  def change
    rename_column :customers, :default, :is_default
  end
end
