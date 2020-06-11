class ApplicationController < ActionController::Base

  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # May 2019 added prepend true based on Devise docs.
  protect_from_forgery with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_account
    @current_account ||= current_user.account if current_user
  end
  helper_method :current_account

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:edit_email])
  end

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
    if current_account.active?
      session["user_return_to"] || welcome_index_path
    else
      welcome_index_path
    end
  end

  def after_sign_out_path_for(resource)
    home_path
  end

end
