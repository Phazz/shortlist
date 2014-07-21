deploy_to   = '/srv/www/shortlist'
rails_root  = "#{deploy_to}/current"
pid_file    = "#{deploy_to}/shared/pids/unicorn.pid"
socket_file = "#{deploy_to}/shared/unicorn.sock"
log_file    = "#{rails_root}/log/unicorn.log"
err_log     = "#{rails_root}/log/unicorn_error.log"
old_pid     = pid_file + '.oldbin'

timeout 30
worker_processes 2 # 4 # Здесь тоже в зависимости от нагрузки, погодных условий и текущей фазы луны
listen socket_file, :backlog => 1024
pid pid_file
stderr_path err_log
stdout_path log_file

preload_app true # Мастер процесс загружает приложение, перед тем, как плодить рабочие процессы.

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=) # Решительно не уверен, что значит эта строка, но я решил ее оставить.

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  # Перед тем, как создать первый рабочий процесс, мастер отсоединяется от базы.
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  # Ниже идет магия, связанная с 0 downtime deploy.
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # После того как рабочий процесс создан, он устанавливает соединение с базой.
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end


# worker_processes 2
# working_directory app_path
# 
# # This loads the application in the master process before forking
# # worker processes
# # Read more about it here:
# # http://unicorn.bogomips.org/Unicorn/Configurator.html
# preload_app true
# 
# timeout 30
# 
# # This is where we specify the socket.
# # We will point the upstream Nginx module to this socket later on
# listen "#{current_path}/tmp/sockets/unicorn.sock", :backlog => 64
# 
# pid "#{current_path}/tmp/pids/unicorn.pid"
# 
# # Set the path of the log files inside the log folder of the testapp
# stderr_path "#{current_path}/log/unicorn.stderr.log"
# stdout_path "#{current_path}/log/unicorn.stdout.log"
# 
# before_fork do |server, worker|
# # This option works in together with preload_app true setting
# # What is does is prevent the master process from holding
# # the database connection
#   defined?(ActiveRecord::Base) and
#     ActiveRecord::Base.connection.disconnect!
# end
# 
# after_fork do |server, worker|
# # Here we are establishing the connection after forking worker
# # processes
#   defined?(ActiveRecord::Base) and
#     ActiveRecord::Base.establish_connection
# end