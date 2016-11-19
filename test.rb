require 'minitest/autorun'
require './app.rb'
require './models/user'
require './models/tweet'
require './models/hashtag'
require './models/relationship'


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

# describe "Create Hashtag" do
#     it "creates a new hashtag" do
#         @hashtag = Hashtag.new(:body => "hashtag", :tweet_id => 1)
#         assert_instance_of Hashtag, @hashtag
#     end
# end

describe "Users can follow other users" do
    it "creates a follow relationship between two users" do
        @user1 = User.new(:username => "testuser1", :password_digest => "password1", :firstname => "test1", :lastname => "user1", :email => "testuser1@sample.com", :birthday => "01/01/1990")
        @user2 = User.new(:username => "testuser2", :password_digest => "password2", :firstname => "test2", :lastname => "user2", :email => "testuser2@sample.com", :birthday => "01/01/1990")
        @user3 = User.new(:username => "testuser3", :password_digest => "password3", :firstname => "test3", :lastname => "user3", :email => "testuser3@sample.com", :birthday => "01/01/1990")
        @user1.followed << @user2
        @user1.followers << @user3
        # puts @user1.followed[0].username
        assert_equal(@user2,@user1.followed[0])
        assert_equal(@user3,@user1.followers[0])
    end
end
