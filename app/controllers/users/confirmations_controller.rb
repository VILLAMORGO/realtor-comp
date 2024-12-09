# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |resource|
      if resource.errors.empty?
        if resource.update(status: 'Approved', trial_ends_at: 90.days.from_now, subscription_status: 'trial')
          UserMailer.with(user: resource).activated_email.deliver_later
        else
          # Handle error if update fails
          flash[:alert] = "There was an error activating your account. Please try again later."
        end
      else
        flash[:alert] = "There was an issue with your confirmation. Please try again."
      end
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
  private
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    authenticated_user_root_path
  end
end
