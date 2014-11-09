class CreateAccount
  def self.call(*args) # class method
    new(*args).call  # instantiate a CreateAccount instance and call the call instance method
  end

  def initialize(params)
    @email = params[:email]
    @account = Account.new(params)
  end

  attr_reader :account, :email #, :plan_id, :mail_list, :name

  # note that running validations (i.e. account.valid? or account.save) will
  # clear the email_not_in_use errors added as this is not included in
  # the Account validations. Therefore evaluate this after the valid? and
  # return without calling save if errors not empty.

  def call  # instance method
    if account.valid? && email_not_in_use  # run validations
      CreateCustomer.call(account) # adds account.stripe_customer_token
      account.user = User.create(email: email)
      AddToMailList.call(email) if mail_list_checked?
      account.save if account.errors.empty?
    end
    return account
  end

  private

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