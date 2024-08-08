class PendingRequestsController < ApplicationController

    before_action :verify_is_admin, only: [:index, :show, :update]

    def index
        @q = User.ransack(params[:q])
        @users = @q.result

        @per_page = (params[:per_page] || 10).to_i
        @page = params[:page] || 1

        @requests = @users.where(status: "Pending")
                        .order(created_at: :desc)
                        .paginate(page: @page, per_page: @per_page)
    end  
    
    def show

    end

    def update
        @user = User.find(params[:id])
    
        if @user.update(status: params[:status])
          if params[:status] == "Approved"
            @user.update(subscription_status: "trial", trial_ends_at: 30.days.from_now)
            # UserMailer.with(user: @user).activated_email.deliver_now
          elsif params[:status] == "Declined"
            # UserMailer.with(user: @user).decline_email.deliver_now
          end
          redirect_to pending_requests_path, notice: "#{@user.email} has been #{@user.status}"
        else
          # Handle update failure
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