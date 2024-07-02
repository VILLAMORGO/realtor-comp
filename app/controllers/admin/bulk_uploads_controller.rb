module Admin
  class BulkUploadsController < ApplicationController

    before_action :verify_is_admin, only: [:new, :create, :index]

    require 'csv'

    def new
      # Logic for new bulk upload
    end

    def create
      if params[:file].present?
        csv_file = params[:file].path
        CSV.foreach(csv_file, headers: true) do |row|
          user_params = row.to_hash
          user = User.new(user_params)
          if user.save
              # UserMailer.with(user: @user).registration_email.deliver_now
          else
            # Handle error for individual user creation
          end
        end
        flash[:notice] = "Users were successfully uploaded."
      else
        flash[:alert] = "Please select a CSV file."
      end
      redirect_to new_admin_bulk_upload_path
    end

    def index
      respond_to do |format|
        format.html
        format.csv { send_data generate_csv_template, filename: "bulk_upload_template.csv" }
      end
    end

    private
    def verify_is_admin
      unless current_user.admin?
        redirect_to authenticated_user_root_path, notice: "You must be an admin to perform this action."
      end
    end

    def generate_csv_template
      CSV.generate(headers: true) do |csv|
        csv << ["first_name", "last_name", "phone_number", "email", "mls_number", "realtor_license_number", "state", "street_address", "home_address", "city_address", "zip_code", "broker_first_name", "broker_last_name", "broker_email", "broker_phone_number", "role", "password", "password_confirmation"]
        csv << ["John", "Doe", "1234567890", "john.doe@example.com", "123456", "7891011", "CA", "1234 Main St", "Apt 101", "Los Angeles", "90001", "Jane", "Smith", "jane.smith@example.com", "0987654321", "agent", "password", "password"]
      end
    end
  end
end
