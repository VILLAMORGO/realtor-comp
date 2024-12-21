module Broker
  class UsersController < ApplicationController
    before_action :verify_is_broker
    before_action :set_pagination_defaults, only: :index

    def index
      @q = User.ransack(params[:q])
      @users = @q.result.where(role: 'agent', broker_email: current_user.email) # Agents linked to the broker
      @agents = @users.paginate(page: @page, per_page: @per_page)

      @total_listings = @users.joins(:listings).count

      @split_data = @users.joins(:listings).group(:first_name).sum(:commission_split)
      @listing_data = @users.joins(:listings).group(:first_name).count

    end

    private

    def verify_is_broker
      unless current_user.broker?
        redirect_to root_path, alert: "You must be broker to perform this action."
      end
    end

    def set_pagination_defaults
      @per_page = [(params[:per_page] || 10).to_i].min.clamp(1, 100)
      @page = [params[:page].to_i, 1].max
    end
  end
end