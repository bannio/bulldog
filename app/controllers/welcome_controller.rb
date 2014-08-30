class WelcomeController < ApplicationController
  before_action :authenticate_user!
  before_action :reroute_cancelled_account_users
   
  def index
  end

  private

  def reroute_cancelled_account_users
    if current_account && !current_account.active?
      flash[:error] = "Your account is not active, you may resubscribe here"
      redirect_to edit_account_path(current_account)
    end
  end
end
