class CreateVatRates < ActiveRecord::Migration
  def change
    create_table :vat_rates do |t|
      t.references :account, index: true
      t.string :name
      t.decimal :rate, precision: 5, scale: 2
      t.boolean :active

      t.timestamps
    end
  end
end