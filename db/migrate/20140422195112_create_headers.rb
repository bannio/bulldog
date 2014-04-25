class CreateHeaders < ActiveRecord::Migration
  def change
    create_table :headers do |t|
      t.string :name
      t.references :account, index: true

      t.timestamps
    end
  end
end
