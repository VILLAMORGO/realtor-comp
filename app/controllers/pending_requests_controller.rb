class PendingRequestsController < ApplicationController

    before_action :verify_is_admin, only: [:index, :show, :update, :destroy]
    VALID_STATUSES = ["Approved", "Declined"]

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

    def destroy
      @user = User.find_by(id: params[:id])
      
      if @user.nil?
        redirect_to pending_requests_path, alert: "User not found."
      elsif @user.destroy
        flash[:notice] = "You successfully deleted #{@user.email}'s application."
        redirect_to pending_requests_path
      else
        flash[:alert] = "Failed to delete the user. Please try again."
        redirect_to pending_requests_path
      end
    end

    def update
      @user = User.find_by(id: params[:id])
      
      if @user.nil?
        redirect_to pending_requests_path, alert: "User not found."
      elsif VALID_STATUSES.include?(params[:status]) && @user.update(status: params[:status])
        handle_status_update(@user, params[:status])
        redirect_to pending_requests_path, notice: "#{@user.email} has been #{@user.status}"
      else
        redirect_to pending_requests_path, alert: "Invalid status or failed to update user. Please try again."
      end
    end

    private

    def handle_status_update(user, status)
      if status == "Approved"
        user.update(subscription_status: "trial", trial_ends_at: 90.days.from_now, confirmed_at: Time.current)
        UserMailer.with(user: user).admin_approval_email.deliver_now
      elsif status == "Declined"
        UserMailer.with(user: user).decline_email.deliver_now
      end
    end    

    def verify_is_admin
      redirect_to root_path, notice: "You must be an admin to perform this action." unless current_user.admin?
    end
end