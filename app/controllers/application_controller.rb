class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # around_filter :scope_current_account

  def after_sign_in_path_for(resource)
    if resource.account.present?
      root_path
    else
      new_account_path
    end
  end

  def user_has_account?
    @has_account ||= current_user ? current_user.account.present? : false
  end
  helper_method :user_has_account?

  def current_account
    @current_account ||= user_has_account? ? current_user.account : nil
  end
  helper_method :current_account

  private

  # def scope_current_account
  #   Account.current_id = current_account.id
  #   yield
  # ensure
  #   Account.current_id = nil
  # end
end
