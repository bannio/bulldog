class AddVatToBills < ActiveRecord::Migration
  def change
    add_reference :bills, :vat_rate, index: true
    add_column :bills, :vat, :decimal, precision: 8, scale: 2
  end
end
