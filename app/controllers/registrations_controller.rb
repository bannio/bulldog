class RegistrationsController < Devise::RegistrationsController

  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy, :edit_email]

  def edit_email
    resource.edit_email = true
    render :edit_email
  end

  # def after_update_path_for(resource)
  #   welcome_index_path
  # end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      logger.info "LINE 22 RegistrationsController #{after_update_path_for(resource)}"
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      if edit_email?
        render :edit_email
      else
        logger.info "LINE 30 RegistrationsController #{after_update_path_for(resource)}"
        respond_with resource
      end
    end
  end

  def edit_email?
    params[:user][:edit_email]
  end

  protected
  
  def after_update_path_for(resource)
    welcome_index_path
  end
 # def create
 #  build_resource(sign_up_params)

 # if resource.save
 #   respond_to do |format|
 #     format.html {
 #       yield resource if block_given?
 #       if resource.active_for_authentication?
 #         set_flash_message :notice, :signed_up if is_flashing_format?
 #         sign_up(resource_name, resource)
 #         respond_with resource, :location => after_sign_up_path_for(resource)
 #       else
 #         set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
 #         expire_data_after_sign_in!
 #         respond_with resource, :location => after_inactive_sign_up_path_for(resource)
 #       end
 #     }
 #     format.js {
 #       flash[:notice] = "Created account, signed in."
 #       render :template => "remote_content/devise_success_sign_up.js.erb"
 #       flash.discard
 #       sign_up(resource_name, resource)
 #     }
 #     end
 #  else
 #     respond_to do |format|
 #       format.html {
 #         clean_up_passwords resource
 #         respond_with resource
 #       }
 #       format.js {
 #         flash[:alert] = resource.errors.full_messages.to_sentence
 #         render :template => "remote_content/devise_errors.js.erb"
 #         flash.discard
 #       }
 #     end
 #  end
 # end
end
