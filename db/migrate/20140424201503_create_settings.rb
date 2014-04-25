class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :account, index: true
      t.string :name
      t.text :address
      t.string :postcode
      t.string :bank_account_name
      t.string :bank_name
      t.string :bank_address
      t.string :bank_account_no
      t.string :bank_bic
      t.string :bank_iban
      t.string :bank_sort

      t.timestamps
    end
  end
end
