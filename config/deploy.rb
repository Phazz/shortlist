set :stages, %w(staging production)
set :default_stage, 'production'
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, 'shortlist'
set :repository,  'git@github.com:bluefox-international/shortlist.git'
set :scm, :git

set :deploy_via, :remote_cache # :copy
# set :copy_strategy, :export
default_run_options[:pty] = true # password prompt from git
ssh_options[:forward_agent] = true # use local ssh key

set :keep_releases, 5
set :use_sudo, false

set :bundle_flags,    '' #'--deployment --verbose'

set :whenever_command, 'bundle exec whenever'

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

after 'deploy:update_code', 'deploy:relink_configs', 'deploy:cleanup'

namespace :deploy do
  task :restart do
    run "if [ -f #{shared_path}/pids/unicorn.pid ] && [ -e /proc/$(cat #{shared_path}/pids/unicorn.pid) ]; then kill -USR2 `cat #{shared_path}/pids/unicorn.pid`; else cd #{release_path} && bundle exec unicorn -c #{release_path}/config/unicorn.rb -E #{rails_env} -D; fi"
  end

  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{deploy_to}/current/config/unicorn.rb -E #{rails_env} -D"
  end

  task :stop do
    run "if [ -f #{shared_path}/pids/unicorn.pid ] && [ -e /proc/$(cat #{shared_path}/pids/unicorn.pid) ]; then kill -QUIT `cat #{shared_path}/pids/unicorn.pid`; fi"
  end

  task :relink_configs, :roles => :app do
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"

    # assets precompile
    run "ln -s #{shared_path}/assets #{release_path}/public/assets"
    run "cd #{release_path}; rake assets:precompile RAILS_ENV=#{rails_env}"
  end

  desc 'Install the bundle'
  task :bundle do
    run (". /home/deployer/.rvm/scripts/rvm && cd #{release_path} && bundle install --without development test")
  end

end

namespace :run_rake do
  desc 'Run a task on a remote server'
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    run("cd #{deploy_to}/current; bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end
