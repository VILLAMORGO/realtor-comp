# Deployment settings
server '140.82.3.49', user: 'root', roles: [:web, :app, :db], primary: true

set :repo_url, 'git@github.com:VILLAMORGO/realtor-comp.git'
set :application, 'realtor-comp'
set :branch, 'main'

set :user, 'root'
set :puma_threads, [4, 16]
set :puma_workers, 0

set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache
set :deploy_to, "/home/ubuntu/#{fetch(:application)}"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :pty, true

set :puma_service_unit_name, 'realtor-comp-puma'
set :puma_restart_command, 'sudo systemctl restart realtor-comp-puma.service'

set :ssh_options, {
  user: 'root',
  keys: %w(~/.ssh/id_ed25519),
  forward_agent: true,
  auth_methods: %w(publickey)
}

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# Set the environment for the cron jobs
set :whenever_environment, -> { fetch(:stage) }

# Update the cron jobs on the server
set :whenever_roles, [:app]

# Set the cron job identifier to your application name
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

append :rbenv_map_bins, 'puma', 'pumactl'
append :linked_files, 'config/master.key'
append :linked_files, 'config/credentials/production.key'

# Puma tasks
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/tmp/sockets #{shared_path}/tmp/pids"
    end
  end

  before 'deploy:starting', 'puma:make_dirs'

  desc 'Restart Puma'
  task :restart do
    on roles(:app) do
      info "Restarting Puma..."
      execute 'sudo systemctl restart realtor-comp-puma.service'
      info "Puma restart command executed."
    rescue => e
      error "Failed to restart Puma: #{e.message}"
    end
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/main`
        puts "WARNING: HEAD is not the same as origin/main"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart Nginx'
  task :restart_nginx do
    on roles(:web) do
      execute :sudo, :systemctl, 'restart nginx'
    end
  end

  # Ensuring Nginx and Puma restart after publishing
  after 'deploy:publishing', 'puma:restart'
  after 'deploy:publishing', 'deploy:restart_nginx'

  after :finishing, 'compile_assets'
  after :finishing, 'cleanup'
end

namespace :puma_config do
  desc "Remove puma.rb file"
  task :rm_files do
    on roles(:all) do
      execute "rm -rf #{release_path}/config/puma.rb"
    end
  end

  desc "Symlink puma.rb file"
  task :add_files do
    on roles(:all) do
      execute "ln -sf #{shared_path}/puma.rb #{release_path}/config/puma.rb"
    end
  end
end

after "deploy:finished", "puma_config:rm_files"
after "deploy:finished", "puma_config:add_files"