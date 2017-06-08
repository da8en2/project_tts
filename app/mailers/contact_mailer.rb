class ContactMailer < ApplicationMailer
  default from: 'dendres82us@gmail.com'

  def contact_email(name, email, phone, subject, message)
    @sender_name = name
    @sender_email = email
    @sender_phone = phone
    @sender_subject = subject
    @sender_message = message
    mail(to: "danielendres@gmail.com", subject: 'Contact Form submitted on danielendres.net ' + " from " + name)
  end

end
