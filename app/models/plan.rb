class Plan < ActiveRecord::Base
  has_many :accounts

  serialize :description, Hash
end
