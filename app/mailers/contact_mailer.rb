class ContactMailer < ActionMailer::Base
    default to: 'hello@bulldogclip.co.uk'

    def contact_email(contact)
        @name = contact.name
        @email = contact.email
        @message = contact.message

        mail(from: @email, subject: 'Contact Request')
    end
end