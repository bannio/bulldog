class CustomFailure < Devise::FailureApp

  # set up in initializers/devise.rb to use this custom failure app
  # config.warden do |manager|
  #   manager.failure_app = CustomFailure
  # end

  def redirect
    message = warden.message || warden_options[:message]
    if message == :timeout     
      redirect_to attempted_path
    else 
      super
    end
  end

  # def redirect_url
  #   if request.xhr?
  #     send(:"remote_sign_in_path", format: :js)
  #   else
  #     super
  #   end
  # end

  # def redirect_url
  #   if warden_message == :timeout
  #     flash[:timedout] = true

  #     path = if request.get?
  #       attempted_path
  #     else
  #       request.referrer
  #     end

  #     path || scope_url
  #   else
  #     scope_url
  #   end
  # end

  # def respond
  #   if http_auth?
  #     http_auth
  #   elsif warden_options[:recall]
  #     recall
  #   else
  #     redirect
  #  end
  # end

end