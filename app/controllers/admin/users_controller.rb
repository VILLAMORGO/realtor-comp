module Admin
    class UsersController < ApplicationController
      before_action :verify_is_admin
  
      def new
        @user = User.new
      end
  
      def create
        @user = User.new(user_params)
        @user.status = "Pending"
        if @user.save
          redirect_to some_path, notice: 'User was successfully created.'
        else
          render :new
        end
      end
  
      private
  
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :status, :first_name, :last_name, :mls_number, :state, :street_address, :home_address, :city_address, :zip_code, :phone_number, :realtor_license_number, :broker_first_name, :broker_last_name, :broker_email, :broker_phone_number, :role)
      end
  
      def verify_is_admin
        unless current_user.admin?
          redirect_to authenticated_user_root_path, notice: "You must be an admin to perform this action."
        end
      end
    end
  end