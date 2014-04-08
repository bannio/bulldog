class CustomFailure < Devise::FailureApp

  # set up in initializers/devise.rb to use this custom failure app
  # config.warden do |manager|
  #   manager.failure_app = CustomFailure
  # end

  def redirect
    message = warden.message || warden_options[:message]
    if message == :timeout     
      redirect_to home_path
    else 
      super
    end
  end

  # def redirect_url
  #   new_user_session_path
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