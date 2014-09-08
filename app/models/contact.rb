class Contact
  include ActiveModel::Model

  attr_accessor( 
    :name,
    :email,
    :message,
    :mail_list
  )

# Name is required and should be less then 30 characters
  validates :name, presence: true, length: { maximum: 30 }
# Email is required and should be a valid email address format
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i ,
    message: "That email looks invalid" }
# Message should be less than 500 characters
  validates :message, length: { maximum: 500 }
# Message or mail list or both must be present they cannot both be blank
  validates :mail_list, acceptance: true,
  unless: Proc.new { |a| a.message.present? }

  def mail_only?
    mail_list == '1' && message.blank?
  end

  def message_only?
    mail_list == '0' && message.present?
  end

  def add_to_mail_list
    # only if there is a to address and the add to list box was checked
    return unless self.email.present? && self.mail_list == '1'
    grouping_id = ENV["MAILCHIMP_GROUP_TYPE_ID"]
    list_id =     ENV["MAILCHIMP_MAIL_LIST"]
    merge_vars =  {groupings: [id: grouping_id, groups: ["Contacts"]]}
    begin
      mailchimp.lists.subscribe(list_id, {'email' => email},merge_vars)
      # mailchimp.lists.subscribe(list_id, {'email' => email},merge_vars,'',false)
    rescue => e
      Rails.logger.error("MAILCHIMP lists.subscribe #{email} to list #{list_id} said: #{e}")
      # don't want to bother the user with success or failure here.
    end
  end

  private
  def mailchimp
    mailchimp ||= Mailchimp::API.new(ENV['MAILCHIMP-API-KEY'])
  end
end