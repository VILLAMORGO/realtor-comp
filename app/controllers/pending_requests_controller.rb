class PendingRequestsController < ApplicationController

    def index
        @request = User.where(role: "agent", status: "Pending").where.not(confirmed_at: nil).order(:confirmed_at)
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
end 