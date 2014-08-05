class AddAttachmentLogoToSettings < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :settings, :logo
  end
end
