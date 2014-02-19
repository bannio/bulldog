module Visible
  extend ActiveSupport::Concern
  module ClassMethods
    def visible_to(person)
      where("#{table_name}.account_id = (?)", current_account.id)
    end 
  end
end