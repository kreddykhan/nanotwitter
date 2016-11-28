require 'json'
require 'redis'


class Stream
    def initialize
        @redis = Redis.new(:port => 4567)
    end

    def cache_tweets(value)
        @redis.set(value, 1)
    end
end
