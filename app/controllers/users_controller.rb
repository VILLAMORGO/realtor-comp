class UsersController < ApplicationController
  before_action :verify_is_admin, only: [:index, :edit, :show, :destroy]

  def index
    @per_page = (params[:per_page] || 10).to_i
    @agents = User.where(role: 'agent', status: "Approved").paginate(page: params[:page], per_page: @per_page)
    @brokers = User.where(role: 'broker', status: "Approved").paginate(page: params[:page], per_page: @per_page)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "You successfully deleted #{@user.email}'s profile."
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