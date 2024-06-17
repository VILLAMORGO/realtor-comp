class UsersController < ApplicationController
  before_action :verify_is_admin, only: [:index, :edit, :show, :create, :new, :destroy]

  def index
    @agents = User.where(role: 'agent', status: "Approved")
    @brokers = User.where(role: 'broker', status: "Approved")
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.state = "Approved"
    @user.skip_confirmation!
    Rails.logger.debug "User Params: #{user_params.inspect}"
    if @user.save
      redirect_to @user, notice: 'New agent was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "You successfully deleted #{@user.email}'s profile."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :status)
  end

  def verify_is_admin
    unless current_user.admin?
      redirect_to authenticated_user_root_path, notice: "You must be an admin to perform this action."
    end
  end
end