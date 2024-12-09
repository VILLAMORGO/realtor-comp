class DeclinedRequestsController < ApplicationController

    before_action :verify_is_admin, only: [:index, :show, :destroy]

    def index
        @q = User.ransack(params[:q])
        @users = @q.result.where(status: "Declined").order(created_at: :desc)
      
        @per_page = (params[:per_page] || 10).to_i
        @page = params[:page] || 1
      
        @requests = @users.paginate(page: @page, per_page: @per_page)
    end

    def show
    
    end

    def destroy
        @user = User.find_by(id: params[:id])
        if @user.nil?
          redirect_to declined_requests_path, alert: "User not found."
        else

            if @user.destroy
                redirect_to declined_requests_path, notice: "You successfully deleted #{@user.email}'s application."
            else
                redirect_to declined_requests_path, alert: "Failed to delete user. Please try again."
            end
        end
    end

    private

    def verify_is_admin
        redirect_to root_path, notice: "You must be an admin to perform this action." unless current_user.admin?
    end

end