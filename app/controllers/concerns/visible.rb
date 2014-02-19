module Visible
  extend ActiveSupport::Concern
  module ClassMethods
    def visible_to(person)
      where("#{table_name}.account_id = (?)", person.account.id)
    end 
  end
end