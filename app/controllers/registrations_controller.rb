class RegistrationsController < Devise::RegistrationsController

  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :edit_email]

  def edit_email
    resource.edit_email = true
    render :edit_email
  end

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
      # if edit_email?
      #   resource.account.update(email: resource.email)
      # end
      # sign_in resource_name, resource, bypass: true  <- Deprecated
      bypass_sign_in(resource, scope: :resource_name)
      logger.info "LINE 28 RegistrationsController after bypass_sign_in #{current_user.email} resource_name #{resource_name}"
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      # our additions here
      if edit_email?
        render :edit_email
      else
        logger.info "LINE 30 RegistrationsController #{after_update_path_for(resource)}"
        # end of additions
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


  private



end
