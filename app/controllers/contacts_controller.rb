class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      if @contact.mail_only?
        flash[:notice] = "Thanks, we have added you to our mailing list."
        @contact.add_to_mail_list
      elsif @contact.message_only?
        flash[:notice] = "Message sent! Thanks for getting in touch, we will get back to you as soon as we can."
        ContactMailer.contact_email(@contact).deliver
      else # they want both
        flash[:notice] = "Message sent! Thanks for getting in touch, we have added you to our mailing list and we will get back to you as soon as we can."
        ContactMailer.contact_email(@contact).deliver
        @contact.add_to_mail_list
      end
      redirect_to home_path 
    else
      flash.now[:alert] = "Your message could not be sent. Please include a message or select add to mailing list before sending."
      render 'new'
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :message, :mail_list)
  end
end