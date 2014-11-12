class CreateAccount
  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @email = params[:email]
    @account = Account.new(params)
  end

  def call
    if account.valid? && email_not_in_use  # run validations
      CreateCustomer.call(account) # adds account.stripe_customer_token
      account.user = User.create(email: email)
      AddToMailList.call(email) if mail_list_checked?
      account.sign_up  # transitions to trialing
      account.save if account.errors.empty?
    end
    return account
  end

  private

  attr_reader :account, :email

  def mail_list_checked?
    account.mail_list == "1"
  end

  def email_not_in_use
    return false unless email
    if User.where(email: email.downcase).empty?
      return true
    else
      account.errors.add(:email, "The email #{email.downcase} is already in use")
      return false
    end
  end
end