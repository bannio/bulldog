class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :account, index: true
      t.references :customer, index: true
      t.date :date
      t.string :number
      t.decimal :total, precision: 8, scale: 2
      t.text :comment

      t.timestamps
    end
  end
end
