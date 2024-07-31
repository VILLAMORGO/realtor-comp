# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Remove existing sample users (agents)
User.where("email LIKE ?", "agent%@test.com").destroy_all

# Create admin accounts
[
  { email: Rails.application.credentials.admin1_email, password: Rails.application.credentials.admin1_password },
  { email: Rails.application.credentials.admin2_email, password: Rails.application.credentials.admin2_password }
].each do |admin_credentials|
  User.find_or_create_by!(email: admin_credentials[:email]) do |user|
    user.password = admin_credentials[:password]
    user.password_confirmation = admin_credentials[:password]
    user.first_name = "Admin"
    user.last_name = "User"
    user.mls_number = "12345678"
    user.state = "VA"
    user.street_address = "streets"
    user.home_address = "home"
    user.city_address = "City"
    user.zip_code = "1234"
    user.status = 'Approved'
    user.role = 'admin'
    user.confirmed_at = DateTime.now
  end
end