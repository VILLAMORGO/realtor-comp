namespace :users do
  desc "Extend trial period for users who started with a 30-day trial"
  task extend_trial: :environment do
    User.where(subscription_status: 'trial').find_each do |user|
      user.extend_trial_period
      Rails.logger.info "Extended trial period for user: #{user.id} - Trial ends at: #{user.trial_ends_at}"
    end
  end
end