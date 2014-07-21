set :scm, :git
set :user, 'deployer'
set :branch, 'master'
set :deploy_to, "/srv/www/#{application}"
set :whenever_environment, 'production'

set :ruby_version,    'ruby-2.1.2'
set :rvm_ruby_string, "#{ruby_version}@#{application}"
set :rvm_path,        '/usr/local/rvm'
set :rvm_bin_path,    "#{rvm_path}/bin"
set :rvm_lib_path,    "#{rvm_path}/lib"
set :ruby_dir,        "#{rvm_path}/rubies/#{ruby_version}"
set :ruby_bin_dir,    "#{ruby_dir}/bin"
set :bundle_dir,      "#{rvm_path}/gems/#{rvm_ruby_string}"

set :default_environment, {
  'PATH'            => "#{rvm_path}:#{rvm_path}/gems/#{rvm_ruby_string}/bin:#{rvm_bin_path}:/usr/lib:$PATH",
  'RUBY_VERSION'    => '2.1.2',
  'GEM_HOME'        => "#{rvm_path}/gems/#{rvm_ruby_string}",
  'GEM_PATH'        => "#{rvm_path}/gems/#{rvm_ruby_string}",
  'BUNDLE_PATH'     => "#{rvm_path}/gems/#{rvm_ruby_string}"
}

server '213.133.101.55', :app, :web, :db, :primary => true

namespace :deploy do
  task :relink_uploads, :roles => :app do
    # run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    # run "ln -nfs #{shared_path}/tmp/cache #{release_path}/tmp/cache"
    # run "ln -nfs #{shared_path}/tmp/sessions #{release_path}/tmp/sessions"
    # run "ln -nfs #{shared_path}/tmp/sockets #{release_path}/tmp/sockets"
  end
end