class AddNextInvoiceToSale < ActiveRecord::Migration
  def change
    add_column :sales, :next_invoice, :date
  end
end
