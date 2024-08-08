class UserMailer < ApplicationMailer
  default from: 'Website@realtorcomp.biz'

  def registration_email
    @user = params[:user]
    Rails.logger.debug "Registration email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been created successfully')
  end

  def approval_email
    @user = params[:user]
    Rails.logger.debug "Approval email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been approved')
    Rails.logger.debug "Mail object created and ready to be sent"
  end

  def decline_email
    @user = params[:user]
    Rails.logger.debug "Decline email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been declined')
  end

  def confirmation_email
    @user = params[:user]
    Rails.logger.debug "Confirmation email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Confirm your email to activate your trial')
  end
end