class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # before_filter :https_redirect

  def after_sign_in_path_for(resource)
    welcome_index_path  # change this when we know where the new user should really start
  end

  def after_sign_out_path_for(resource)
    home_path
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

  def record_not_found
    flash[:alert] = "Item not found or not authorised"
    redirect_to home_path
  end

  # def https_redirect
  #     if ENV["ENABLE_HTTPS"] == "yes"
  #       if request.ssl? && !use_https? || !request.ssl? && use_https?
  #         protocol = request.ssl? ? "http" : "https"
  #         flash.keep
  #         redirect_to protocol: "#{protocol}://", status: :moved_permanently
  #       end
  #     end
  #   end

  #   def use_https?
  #     true # Override in other controllers
  #   end
end
