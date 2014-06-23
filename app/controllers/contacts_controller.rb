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
        flash[:notice] = "Message sent! Thanks for getting in touch."
        ContactMailer.contact_email(@contact).deliver
      else # they want both
        flash[:notice] = "Message sent! Thanks for getting in touch, we have added you to our mailing list."
        ContactMailer.contact_email(@contact).deliver
        add_to_mail_list
      end
      redirect_to home_path 
    else
      redirect_to '/contact', notice: "Your message could not be sent. Please write a message or select add to mailing list before sending."
    end
  end

  def add_to_mail_list
    # take email and add to mail list
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :message, :mail_list)
  end
end