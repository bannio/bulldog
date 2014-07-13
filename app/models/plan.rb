class Plan < ActiveRecord::Base
  has_many :accounts

  serialize :description, Hash

  # See Account for mapping of plans to names
end
