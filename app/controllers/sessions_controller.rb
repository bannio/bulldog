class SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    # self.resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    # self.resource = warden.authenticate!(scope: resource_name, redirect: "#{new_user_session_path}")
    respond_to do |format|
      format.html {
            set_flash_message(:notice, :signed_in) if is_flashing_format?
            sign_in(resource_name, resource)
            yield resource if block_given?
            respond_with resource, location: after_sign_in_path_for(resource)
          }
      format.js {
        flash[:notice] = "signed in successfully."
        sign_in(resource_name, resource)
        render :template => "remote_content/devise_success_sign_in.js.erb"
        flash.discard       
      }
    end
  end

  def new
    respond_to do |format|
      format.html {
        Rails.logger.info "in the HTML side of the SessionsController#new method"
        super
      }
      format.js {
        Rails.logger.info "in the JS side of the SessionsController#new method"
          flash[:alert] = "Sign in failed"
          render :template => "remote_content/devise_errors.js.erb"
          flash.discard
      }
    end
  end
end