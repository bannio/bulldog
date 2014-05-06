class AddVatRegNoToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :vat_reg_no, :string
  end
end
