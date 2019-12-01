class UserMailer < ApplicationMailer
  default :from => "shardax2000@gmail.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Registration Confirmation")
  end

  def approval(user)
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Your 2Unstoppable Profile Has Been Approved")
  end

  def forgot_username(user)
    @user = user
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Username Reminder")
  end

  def inform_admins_new_registration(user)
    @user = user
    recipients = User.all.select{|x| x.admin?}.collect{|x| x.email}.join(', ')
    mail(:to => recipients, :subject => "User: #{user.username}, Email: #{user.email} has confirmed")
  end

  def inform_message_recipient(user, recipient)
    @user = user
    @recipient = recipient
    mail(:to => "#{recipient.username} <#{recipient.email}>", :subject => "You've received a new message on 2Unstoppable")
  end
end
