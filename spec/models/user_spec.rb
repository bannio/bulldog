require 'rails_helper'

describe User do

  before(:each) do
    @attr = {
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    expect(no_email_user).to_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      expect(valid_email_user).to be_valid
    end
  end

  it "should reject invalid email addresses" do
    # addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses = %w[user@foo@com user_at_foo.org]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      expect(invalid_email_user).to_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).to_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).to_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      expect(@user).to respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      expect(@user).to respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should not require a password when new" do
      expect(User.new(@attr.merge(:password => "", :password_confirmation => ""))).
        to be_valid
    end

    it "should not require a matching password confirmation when new" do
      expect(User.new(@attr.merge(:password_confirmation => "invalid"))).
        to be_valid
    end

    it "should require a password when persisted" do
      user = User.create!(@attr)
      expect(user.update_attributes(password: "")).
        to_not be_truthy
    end

    it "should require a matching password confirmation when persisted" do
      user = User.create!(@attr)
      expect(user.update_attributes(password_confirmation: "invalid")).
        to_not be_truthy
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      expect(User.new(hash)).to_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      expect(@user).to respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      expect(@user.encrypted_password).to_not be_blank
    end

  end

  # describe "before_update email" do
  #   it "updates the account email" do
  #     user = User.create(@attr)
  #     account = Account.new(user_id: user.id)
  #     expect(account).to receive(:update).with(email: "new@example.com")
  #     user.update(email: "new@example.com")
  #   end
  # end

# accounts now create user rather than user creating account
  # describe "account creation" do
  #   before(:each) do
  #     @user = User.create!(@attr)
  #   end
  #   it "should create an account object and persist it" do
  #     @user.account_set_up({account_name: "test"})
  #     expect(@user.reload.account.name).to eq "test"
  #   end
  # end

end

