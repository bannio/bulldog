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
      # allow_any_instance_of(Account).to receive(:get_customer).and_return(true)
      # allow_any_instance_of(Account).to receive(:process_sale).and_return(true)

      @account = FactoryGirl.create(:account, user_id: @user.id)
      @user.confirm!
      sign_in @user
    end
  end

  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end

  def current_user
    user_session_info = response.request.env["rack.session"]["warden.user.key"]
    if user_session_info
      user_id = user_session_info[0][0]
      User.find(user_id)
    else
      nil
    end
  end

  def user_signed_in?
    !!current_user
  end

  
  # Note that @account is set in login_user
  # setting is always created by Account after_save, create_setting adds more attributes

  def create_setting
    before(:each) do
      @account.setting.update_attributes(attributes_for(:setting)).save
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