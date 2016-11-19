require 'minitest/autorun'
require './app.rb'
require './models/user'
require './models/tweet'
require './models/hashtag'


describe "Create User" do
    it "creates a new user" do
        @user = User.new(:username => "testuser", :password_digest => "password", :firstname => "test", :lastname => "user", :email => "testuser@sample.com", :birthday => "01/01/1990")
        assert_instance_of User, @user
    end
end

describe "Create Tweet" do
    it "creates a new tweet" do
        @tweet = Tweet.new(:body => "tweetbody", :user_id => 1)
        assert_instance_of Tweet, @tweet
    end
end

describe "Create Hashtag" do
    it "creates a new hashtag" do
        @hashtag = Hashtag.new(:body => "hashtag", :tweet_id => 1)
        assert_instance_of Hashtag, @hashtag
    end
end
