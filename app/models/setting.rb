class Setting < ActiveRecord::Base
  include Visible
  
  belongs_to :account

  has_attached_file :logo, :styles => { :medium => "500x500>", :thumb => "200x100>" },
    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

end
