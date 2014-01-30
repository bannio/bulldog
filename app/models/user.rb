class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable, :timeoutable

  has_one :account

  def after_database_authentication
    # set current_account here ?
  end
end
