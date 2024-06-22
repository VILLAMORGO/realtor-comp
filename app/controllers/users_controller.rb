class UsersController < ApplicationController
  before_action :verify_is_admin, only: [:index, :edit, :show, :destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result

    @per_page = (params[:per_page] || 10).to_i
    @page = params[:page] || 1

    # Fetching agents and brokers separately with pagination
    @agents = @users.where(role: 'agent', status: 'Approved').paginate(page: @page, per_page: @per_page)
    @brokers = @users.where(role: 'broker', status: 'Approved').paginate(page: @page, per_page: @per_page)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          agents: @agents,
          brokers: @brokers,
          agents_pagination: {
            current_page: @agents.current_page,
            total_pages: @agents.total_pages,
            per_page: @agents.per_page,
            total_entries: @agents.total_entries
          },
          brokers_pagination: {
            current_page: @brokers.current_page,
            total_pages: @brokers.total_pages,
            per_page: @brokers.per_page,
            total_entries: @brokers.total_entries
          }
        }
      }
    end
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

  def approve
    @user = User.find(params[:id])
    if @user.update(status: "Approved")
      UserMailer.with(user: @user).approval_email.deliver_later
      flash[:notice] = "User approved and notification email sent."
    else
      flash[:alert] = "There was an error approving the user."
    end
    redirect_to users_path
  end
  
end