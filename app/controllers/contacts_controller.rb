class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      if @contact.mail_only?
        flash[:notice] = "Thanks, we have added you to our mailing list."
        add_to_mail_list
      elsif @contact.message_only?
        flash[:notice] = "Message sent! Thanks for getting in touch, we will get back to you as soon as we can."
        ContactMailer.contact_email(@contact).deliver
      else # they want both
        flash[:notice] = "Message sent! Thanks for getting in touch, we have added you to our mailing list and we will get back to you as soon as we can."
        ContactMailer.contact_email(@contact).deliver
        add_to_mail_list
      end
      redirect_to home_path 
    else
      flash[:alert] = "Your message could not be sent. Please include a message or select add to mailing list before sending."
      render 'new'
    end
  end

  def add_to_mail_list
    # take email and add to mail list
  #   list_id = ENV["MAILCHIMP_MAIL_LIST"]
  #   email = params['email']
  #   begin
  #     @mc.lists.subscribe(params[:id], {'email' => email})
  #     flash[:success] = "#{email} subscribed successfully"
  #   rescue Mailchimp::ListAlreadySubscribedError
  #     flash[:error] = "#{email} is already subscribed to the list"
  #   rescue Mailchimp::ListDoesNotExistError
  #     flash[:error] = "The list could not be found"
  #     # redirect_to "/lists/"
  #     return
  #   rescue Mailchimp::Error => ex
  #     if ex.message
  #       flash[:error] = ex.message
  #     else
  #       flash[:error] = "An unknown error occurred"
  #     end
  #   end
  #   # redirect_to "/contact"
  # end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :message, :mail_list)
  end
end