class Plan < ActiveRecord::Base
  has_many :accounts

  # description not used now!

  serialize :description, Hash

  # See Account for mapping of plans to names
end
