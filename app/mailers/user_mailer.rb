class UserMailer < ApplicationMailer
  default from: 'Website@realtorcomp.biz'

  def registration_email
    @user = params[:user]
    Rails.logger.debug "Registration email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been created successfully')
  end

  def activated_email
    @user = params[:user]
    Rails.logger.debug "Approval email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been activated')
    Rails.logger.debug "Mail object created and ready to be sent"
  end

  def subscribed_email
    @user = params[:user]
    Rails.logger.debug "Subscription email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your subscription payment succedded')
    Rails.logger.debug "Mail object created and ready to be sent"
  end

  def extended_trial_email
    @user = params[:user]
    Rails.logger.debug "Extended Trial email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your Free Trial Has Been Extended!')
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

  def admin_approval_email
    @user = params[:user]
    Rails.logger.debug "Approval email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your account has been approved')
  end

  def subscription_expired_email
    @user = params[:user]
    Rails.logger.debug "Expired subscription email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your subscription has expired')
  end

  def extended_trial_expired_email
    @user = params[:user]
    Rails.logger.debug "Expired subscription email user: #{@user.inspect}"
    mail(to: @user.email, subject: 'Your 90 days free trial has expired')
  end
end