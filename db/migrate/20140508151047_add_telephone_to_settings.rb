class AddTelephoneToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :telephone, :string
    add_column :settings, :email, :string
  end
end
