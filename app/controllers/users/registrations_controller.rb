# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.status = 'Pending' # Set initial status to 'Pending'
    
    Rails.logger.info "Starting reCAPTCHA validation for user registration."

    # Verify the reCAPTCHA response
    recaptcha_valid = verify_recaptcha(model: @user, action: 'registration', secret_key: Rails.application.credentials.recaptcha_v3.recaptcha_secret_key)
    if recaptcha_valid
      Rails.logger.info "reCAPTCHA validation succeeded."

      if resource.save
        Rails.logger.info "User registration successful: #{resource.email}"
        resource.send_confirmation_instructions # Send confirmation email
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
        flash[:notice] = "Please confirm your email to activate your free 30-day trial."
      else
        Rails.logger.error "User registration failed: #{resource.errors.full_messages.join(', ')}"
        # clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      Rails.logger.warn "reCAPTCHA validation failed for user: #{resource.email}"
      # Score is below threshold, so user may be a bot. Show a challenge, require multi-factor
      # authentication, or do something else.
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
      flash.now[:alert] = "reCAPTCHA verification failed. Please try again."
    end
    # Flash notice for pending account approval
    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :mls_number, :state,:street_address, :home_address, :city_address, :zip_code, :phone_number, :realtor_license_number, :broker_first_name, :broker_last_name, :broker_email, :broker_phone_number, :role, :profile_picture, :g_recaptcha_response])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :mls_number, :state, :street_address, :home_address, :city_address, :zip_code, :phone_number, :realtor_license_number, :broker_first_name, :broker_last_name, :broker_email, :broker_phone_number, :role, :profile_picture])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end