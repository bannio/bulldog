class AddColumnsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :include_vat, :boolean
    add_column :settings, :include_bank, :boolean
  end
end
