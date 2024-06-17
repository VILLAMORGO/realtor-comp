require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "approval_email" do
    user = User.create!(
      name: "Test User",
      email: "user_#{SecureRandom.uuid}@example.com",  # Generates a unique email
      password: "password",
      approved: false
    )

    email = UserMailer.approval_email(user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [user.email], email.to
    assert_equal "Your account has been approved", email.subject
    assert_match "Your account has been approved", email.body.to_s
  end
end
