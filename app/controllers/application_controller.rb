class ApplicationController < ActionController::Base

  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # before_action :check_account_active

  def current_account
    @current_account ||= current_user.account if current_user
  end
  helper_method :current_account

  private

  def record_not_found
    flash[:alert] = "Item not found or not authorised"
    redirect_to (request.referrer || home_path)
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || home_path)
    # redirect_to home_path
  end

  def after_sign_in_path_for(resource)
    session["user_return_to"] || welcome_index_path
  end

  def after_sign_out_path_for(resource)
    home_path
  end

  def check_account_active
    if current_account && !current_account.active?
      flash[:error] = "Your account is not active, you may resubscribe here"
      # redirect_to edit_account_path(current_account)
    end
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
