worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 30
preload_app true

listen 3000
pid File.expand_path('../../log/unicorn.pid', __FILE__)

stdout_path File.expand_path('../../log/unicorn_stdout.log', __FILE__)
stderr_path File.expand_path('../../log/unicorn_stderr.log', __FILE__)

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
