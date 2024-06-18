# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create(
    email: Rails.application.credentials.admin_email, 
    password: Rails.application.credentials.admin_password, 
    password_confirmation: Rails.application.credentials.admin_password,
    first_name: "admin", 
    last_name: "test", 
    mls_number: "12345678", 
    state: "VA", 
    street_address: "streets", 
    home_address: "home", 
    city_address: "City", 
    zip_code: "1234",
    status: 'Approved',
    role: 'admin',
    confirmed_at: DateTime.now
)

30.times do |i|
    User.create(
        email: "agent#{i+1}@test.com",
        password: 'agentpassword123',
        password_confirmation: 'agentpassword123',
        first_name: "Agent#{i+1}",
        last_name: "Test",
        mls_number: "8765432#{i+1}",
        state: "VA",
        street_address: "Street #{i+1}",
        home_address: "Home #{i+1}",
        city_address: "City",
        zip_code: "1234#{i+1}",
        status: 'Pending',
        role: 'agent',
        confirmed_at: DateTime.now
    )
  end