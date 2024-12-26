module SubscriptionsHelper
  def days_left
    if current_user.subscription_status == "trial" && current_user.trial_ends_at.present? 
     return current_user.trial_ends_at.to_date - Date.current  
    end 
  end
end