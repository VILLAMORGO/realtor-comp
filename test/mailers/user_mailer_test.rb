require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "approval_email" do
    # Create a user with status 'Pending'
    user = User.create!(
      email: "user_#{SecureRandom.uuid}@example.com",
      password: "password",
      status: "Pending",
      first_name: "Test",
      last_name: "User",
      state: "VA",
      street_address: "123 Test St",
      home_address: "123 Test Home",
      city_address: "Test City",
      zip_code: "12345",
      phone_number: "1234567890",
      realtor_license_number: "87654321",
      broker_first_name: "Broker",
      broker_last_name: "Name",
      broker_email: "broker@example.com",
      broker_phone_number: "0987654321"
    )

    # Clear the deliveries array before the test
    ActionMailer::Base.deliveries.clear

    # Update the user's status to "Approved" to simulate approval and trigger the email
    user.update!(status: "Approved")

    # Check that one email was sent
    assert_equal 1, ActionMailer::Base.deliveries.size

    # Get the sent email
    email = ActionMailer::Base.deliveries.last

    # Assertions to check the email content
    assert_equal [user.email], email.to
    assert_equal "Your account has been approved", email.subject
    assert_match "Your account has been approved", email.body.to_s
  end
end