require 'json'
require 'redis'

class TweetStream

  REDIS_KEY = 'tweets'
  NUM_TWEETS = 20
  TRIM_THRESHOLD = 100

  def initialize
    @db = Redis.new(:port => 4567)
    @trim_count = 0
  end

end
