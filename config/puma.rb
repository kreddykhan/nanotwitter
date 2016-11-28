workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 4567
environment ENV['RACK_ENV'] || 'development'

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!

  if defined?(Resque)
     Resque.redis = ENV["<redis-uri>"] || "redis://127.0.0.1:6379"
  end
end

on_worker_boot do
  ActiveRecord::Base.connection.reconnect!
  $redis.client.reconnect
end

# web: bundle exec puma -C config/puma.rb
