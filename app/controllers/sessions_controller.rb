class SessionsController < Devise::SessionsController

  skip_before_filter :verify_authenticity_token

  # POST /resource/sign_in
  def create
    # self.resource = warden.authenticate!(auth_options)
    respond_to do |format|
      format.html {
        super
      }
      format.js {
        self.resource = warden.authenticate!(auth_options)
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

        Rails.logger.info "flash timedout = #{flash[:timedout]} and alert = #{flash[:alert]}"
        self.resource = resource_class.new(sign_in_params)
        render template: "remote_content/remote_sign_in.js.erb"
        flash.discard
      }
    end
  end
end