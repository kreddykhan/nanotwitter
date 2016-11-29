require 'zlib'
require 'redis'

configure :production, :development do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
  :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
  )

  uri = URI.parse(ENV['REDISTOGO_URL']  || 'postgres://localhost/mydb')
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
