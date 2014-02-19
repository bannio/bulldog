class AddInvoiceToBills < ActiveRecord::Migration
  def change
    add_reference :bills, :invoice, index: true
  end
end
