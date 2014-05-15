class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless (value.is_a?(Date) || value =~ /\A\d{4}-\d{2}-\d{2}\z/) && 
      begin
        value.to_date.is_a?(Date)
      rescue ArgumentError
        false
      end
      record.errors[attribute] << (options[:message] || "#{attribute.to_s.humanize} is not a valid 'yyyy-mm-dd' date")
    end
  end
end