class UserMailer < ApplicationMailer
  default from: 'villamorgo@gmail.com'

  def registration_email
    @user = params[:user]
    Rails.logger.debug "Registration email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been created successfully')
  end

  def approval_email
    @user = params[:user]
    Rails.logger.debug "Approval email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been approved')
  end

  def decline_email
    @user = params[:user]
    Rails.logger.debug "Decline email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been declined')
  end
end