class AddTotalToSale < ActiveRecord::Migration
  def change
    add_column :sales, :invoice_total, :integer
    add_column :sales, :stripe_invoice_id, :string
  end
end
