class AddDefaultToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :default, :boolean
  end
end
