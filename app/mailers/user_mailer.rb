class UserMailer < ApplicationMailer
    default from: 'no-reply@example.com'
  
    def approval_email(user)
      @user = user
      mail(to: @user.email, subject: 'Your account has been approved')
    end
end  
