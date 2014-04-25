class AddHeadersToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :header
    add_column :invoices, :include_bank, :boolean
    add_column :invoices, :include_vat, :boolean
  end
end
