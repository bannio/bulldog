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
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
# Message should be less than 400 characters
  validates :message, length: { maximum: 400 }
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
    # if message.present?
  # end
  end
end