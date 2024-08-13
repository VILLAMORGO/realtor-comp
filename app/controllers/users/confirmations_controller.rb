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
        resource.update(status: 'Approved', trial_ends_at: 90.days.from_now, subscription_status: 'trial')
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
