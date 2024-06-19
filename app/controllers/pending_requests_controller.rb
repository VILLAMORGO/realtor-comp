class PendingRequestsController < ApplicationController

    before_action :verify_is_admin, only: [:index, :show, :update]

    def index
        @per_page = params[:per_page] || 10
        @requests = User.where(role: "agent", status: "Pending")
                        .where.not(confirmed_at: nil)
                        .order(:confirmed_at)
                        .paginate(page: params[:page], per_page: @per_page)
    end  
    
    def show

    end

    def update
        @user = User.find(params[:id])
        
        if @user.update(status: params[:status])
        #   UserMailer.with(user: @user).approve_email.deliver_now if params[:status] == "Approved"
        #   UserMailer.with(user: @user).decline_email.deliver_now if params[:status] == "Declined"
          redirect_to pending_requests_path, notice: "#{@user.email} has been #{@user.status}"
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