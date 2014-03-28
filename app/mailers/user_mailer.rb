class UserMailer < ActionMailer::Base

  def welcome_email(user)
    @user = user
    @login_url  = 'https://flesh.io/login'
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(to: email_with_name, subject: 'Welcome to Flesh!')
  end

end
