class FairShareMailer < ActionMailer::Base

  def send_welcome_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, from: "FairShare@fmes.org", subject: "Welcome to Fair Share"
  end

  def send_registered_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, from: "FairShare@fmes.org", subject: "Thank you for registering on Fair Share!"
  end

  def send_thank_you_for_sharing_email(user, hour)
    @user = user
    @hour = hour
    mail to: @user.email, from: "FairShare@fmes.org", subject: "Thank you for sharing your time with us"
  end
end
