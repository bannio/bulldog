class AddTrialEndToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :trial_end, :datetime
  end
end
