class DeclinedRequestsController < ApplicationController

    before_action :verify_is_admin, only: [:index, :show, :destroy]

    def index
        @q = User.ransack(params[:q])
        @users = @q.result

        @per_page = (params[:per_page] || 10).to_i
        @page = params[:page] || 1

        @requests =  @users.where(status: "Declined")
                           .order(created_at: :desc)
                           .paginate(page: @page, per_page: @per_page)
    end

    def show
    
    end

    def destroy
        @user = User.find(params[:id])
        
        if @user.destroy
          redirect_to declined_requests_path, notice: "You successfully deleted #{@user.email}'s application."
        end
    end

    private

    def verify_is_admin
        if current_user.admin?
           return
        else
           redirect_to root_path, notice: "You must be an admin to perform this action."
        end
    end

end