class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :name
      t.text :address
      t.string :postcode

      t.timestamps
    end
  end
end
