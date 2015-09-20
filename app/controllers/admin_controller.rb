class AdminController < ApplicationController
  before_action :require_admin

  def show
  end

  def send_registration_emails
    @unregistered_users = User.where.not(registration_token: "")
    @unregistered_users.each do |user|
      FairShareMailer.delay.send_welcome_email(user.id)
    end
    redirect_to current_admin
  end
end
