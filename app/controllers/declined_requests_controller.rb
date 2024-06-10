class DeclinedRequestsController < ApplicationController

    before_action :verify_is_admin, only: [:index, :show, :destroy]

    def index
        @request =  User.where(role: "agent", status: "Declined").where.not(confirmed_at: nil).order(confirmed_at: :DESC)
    end

    def show
    
    end

    def destroy
        @user = User.find(params[:id])
        
        if @user.destroy
          UserMailer.with(user: @user).destroy_account_email.deliver_now
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