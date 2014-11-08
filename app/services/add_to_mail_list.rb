class AddToMailList

  def self.call(*args) # class method
    new(*args).call  # instantiate a CreateAccount instance and call the call instance method
  end

  def initialize(email)
    @email = email
  end

  attr_reader :email

  def call
    return unless email
    grouping_id = ENV["MAILCHIMP_GROUP_TYPE_ID"]
    list_id = ENV["MAILCHIMP_MAIL_LIST"]
    merge_vars = {groupings: [id: grouping_id, groups: ["Users"]]}
    begin
      mailchimp.lists.subscribe(list_id, {'email' => email},merge_vars)
    rescue => e
      Rails.logger.error("MAILCHIMP lists.subscribe #{email} to list #{list_id} said: #{e}")
      # don't want to bother the user with success or failure here.
    end
  end
  def mailchimp
    mailchimp ||= Mailchimp::API.new(ENV['MAILCHIMP-API-KEY'])
  end
end
