class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :account, index: true
      t.references :customer, index: true
      t.references :supplier, index: true
      t.references :category, index: true
      t.text :description
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
