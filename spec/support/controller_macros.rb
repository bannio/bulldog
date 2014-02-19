module ControllerMacros
  # def login_admin
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:admin]
  #     sign_in FactoryGirl.create(:admin) # Using factory girl as an example
  #   end
  # end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @user.confirm!
      sign_in @user
    end
  end

  def create_account
    before(:each) do
      @account = FactoryGirl.create(:account, user_id: @user.id)
    end
  end

  def create_customer
    before(:each) do
      @customer = FactoryGirl.create(:customer, account_id: @account.id)
    end
  end

  def create_bill
    before(:each) do
      @bill = FactoryGirl.create(:bill, account_id: @account.id, customer_id: @customer.id )
    end
  end
end