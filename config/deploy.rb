# Change these
server '159.203.16.242', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'https://github.com/jules2689/personal_dashboard.git'
set :application,     'personal_dashboard'
set :user,            'deploy'

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :thin_config_path, -> { "#{shared_path}/config/thin.yml" }
set :ssh_options, forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub)

set :default_env, 'RACK_ENV' => 'production'

set :linked_files, %w(.env config/thin.yml history.yml)
set :linked_dirs,  %w(log)

namespace :thin do
  desc 'Create Directories for Thin Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'thin:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'thin:restart'
    end
  end

  desc "Precompile assets to public/assets"
  task :precompile_assets do
    on roles(:app) do
      within current_path do
        execute :rake, "assets:precompile"
      end
    end
  end

  desc "Migrates the DB"
  task :migrate_db do
    on roles(:app) do
      within current_path do
        execute :rake, 'db:migrate'
      end
    end
  end

  desc "Starts Dashing"
  task :start_dashing do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "dashing start -d"
      end
    end
  end

  before :starting,    :check_revision
  before :finishing,   :precompile_assets
  before :finishing,   :migrate_db
  after :finishing,    :cleanup
  after :finishing,    :restart
  after :finishing,    :start_dashing
end

namespace :ssl do
  desc 'renew SSL'
  task :renew do
    on roles(:app) do
      within current_path do
        rake "ssl:renew"
        puts "Restarting nginx"
        execute :sudo, "service nginx restart"
      end
    end
  end
end
