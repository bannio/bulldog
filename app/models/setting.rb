class Setting < ActiveRecord::Base
  include Visible
  
  belongs_to :account

end
