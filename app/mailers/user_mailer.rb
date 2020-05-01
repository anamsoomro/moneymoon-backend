class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]
 
  def welcome_email
    @user = params[:user]
    mail(to: params[:email], subject: "join APPNAME with #{@user}")
  end
  
end
