# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Clear cron: crontab -r
# Update cron: whenever --update-crontab
# Update cron development: whenever --update-crontab --set --environment='development'

set :output, "./log/cron.log"
set :bundle_command, "/usr/local/rvm/gems/ruby-3.3.0/bin/bundle"

env :SHELL, '/bin/bash'
env :PATH, ENV['PATH']

# Adjust the path to `rails` if needed
rails_path = "/usr/local/rvm/gems/ruby-3.3.0/bin/rails
"

every 1.hour do
  command "cd /home/ubuntu/realtor-comp && #{rails_path} runner 'Subscription.check_expired_subscriptions' -e production"
end

every 1.hour do
  command "cd /home/ubuntu/realtor-comp && #{rails_path} runner 'User.check_expired_trials' -e production"
end