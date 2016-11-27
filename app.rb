require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/user'
require './models/tweet'
require './models/relationship'
require 'csv'
require 'faker'

enable :sessions
set :session_secret, "super secret"

get '/' do
    @users = User.all
    @tweets = Tweet.all.order('date DESC')
    # @users.each do |user|
    #     puts user.id
    #     puts user.username
    #     puts user.firstname
    # end
  erb :index
end

get '/signup' do
  erb :signup
end

get '/login' do
  erb :login
end

get '/home' do
  if logged_in?
      @user = User.find(session[:user_id])
      @user_tweets = @user.tweets
      @followers = @user.followed
      @follower_tweets = Tweet.of_followed_users(@user.followed).order('date DESC')
      erb :home
  else
    redirect "/login"
  end
end

get '/home/followers' do
  if logged_in?
      @user = User.find(session[:user_id])
      @followers = @user.followers
      erb :home_followers
  else
    redirect "/login"
  end
end

get '/home/tweets' do
  if logged_in?
      @user = User.find(session[:user_id])
      @user_tweets = @user.tweets
      erb :home_tweets
  else
    redirect "/login"
  end
end

get '/followers' do
    user_id = params[:id].to_i
    if user_id == session[:user_id]
        redirect '/home/followers'
    else
        @user = User.find(user_id)
        @followers = @user.followers
        erb :followers
    end
end

get '/tweets' do
    user_id = params[:id]
    if user_id == session[:user_id]
        redirect '/home/tweets'
    else
        @user = User.find(user_id)
        @user_tweets = @user.tweets
        erb :tweets
    end
end

get '/failure' do
  erb :failure
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    # puts @tweet.id
    # puts @tweet.body
    # puts @tweet.user_id
    erb :tweet
end

get '/users/:id' do
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
        redirect '/home'
    else
        @user_tweets = @user.tweets
        @followers = @user.followed
        @follower_tweets = Tweet.of_followed_users(@user.followed).order('date DESC')
        erb :user
    end
end

get '/users/:id/tweets' do
    redirect "/users/#{params[:id].to_i}"
end

get '/tweets/recent' do
    redirect '/'
end

# get '/example' do
#     # if logged_in?
#     @user = User.find(1)
#         # @user_tweets = Tweet.where(user_id: @user.id)
#         @user_tweets = @user.tweets
#         @followers = @user.followed
#         @follower_tweets = Tweet.of_followed_users(@user.followed).order('date DESC')
#         # @followers = User.find(@user.id).followed
#         # @follower_tweets = @followers.tweets
#         # @tweets =
#       #   @tweets.each do |tweet|
#       #       puts tweet.id
#       #       puts tweet.body
#       #       puts tweet.user_id
#       #   end
#         erb :example
#     # else
#     #   redirect "/login"
#     # end
# end

post "/signup" do
  @user = User.new(params[:user])
  if @user.save
    redirect '/login'
  else
    redirect '/failure'
  end
end

post '/login' do
  @user = User.find_by(:username => params[:login]['username'])
  if @user && @user.authenticate(params[:login]['password'])
    session[:user_id] = @user.id
    redirect '/home'
  else
    redirect '/failure'
  end
end

post '/tweet' do
    if logged_in?
        @tweet = Tweet.new(:body => params[:tweet]['body'],:user_id => session[:user_id],:date => Time.now.getutc)
        redirect '/home/tweets'
    else
        redirect '/login'
    end
end

post '/follow' do
    @user = User.find(session[:user_id])
    if logged_in?
        @user2 = User.find(params[:id].to_i)
        if @user.followed.exclude?(@user2)
            @user.followed << @user2
        end
        redirect "/followers?id=#{@user2.id}"
    else
        redirect '/login'
    end
end

############################## Test Environment ##############################

get '/test/status' do
    erb :status
end

get '/test/reset/all' do
    Tweet.destroy_all
    Relationship.destroy_all
    User.destroy_all
    ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
    @user = User.new(:username => "testuser", :password => "password", :firstname => "test", :lastname => "user", :email => "testuser@sample.com", :birthday => "01/01/1990")
    @user.save
    redirect '/'
end

get '/test/reset/standard' do
    Tweet.destroy_all
    Relationship.destroy_all
    User.destroy_all
    ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
    load 'db/seeds.rb'
    n = params[:tweets]
    if n!=nil
        tweet_number(n)
    end
    redirect '/test/status'
end

get '/test/reset/testuser' do
    @user = User.find_by(:username => 'testuser')
    if @user!=nil
        Tweet.where(user_id: @user.id).delete_all
        Relationship.where(user_id: @user.id).delete_all
        @user.delete
    end
    ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
    @user = User.new(:username => "testuser", :password => "password", :firstname => "test", :lastname => "user", :email => "testuser@sample.com", :birthday => "01/01/1990")
    @user.save
    redirect '/'
end

get '/test/users/create' do
    user_number = params[:count].to_i
    tweet_number = params[:tweets].to_i

    if user_number == nil
        user_number = 1
    end

    if tweet_number == nil
        tweet_number = 0
    end

    user_number.times do
        first_name = Faker::Name.first_name
        params = {:username => first_name, :password => 'test', :firstname => first_name, :lastname => Faker::Name.last_name, :email => Faker::Internet.email(first_name), :birthday => Faker::Date.backward(20)}
        @user = User.new(params)
        @user.save
        make_tweets(tweet_number,@user)
    end
    redirect '/'
end

get '/test/user/follow' do
    @users = User.all
    follow_number = params[:count].to_i
    follow_number.times do
        @user1 = @users.sample
        follow_number.times do
            @user2 = @users.sample
            @user1.followed << @user2
        end
    end
    redirect '/'
end

get '/test/user/:u/tweets' do
    tweet_number = params[:count].to_i
    @user = User.find(params[:u].to_i)
    make_tweets(tweet_number,@user)
    redirect "/users/#{@user.id}"
end

get '/test/user/:u/follow' do
    follow_number = params[:count].to_i
    @user = User.find(params[:u].to_i)
    @users = User.all
    follow_number.times do
        @user2 = @users.sample
        @user.followed << @user2
    end
end

############################## Helper Methods ##############################

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def tweet_number(n)
      n = n.to_i
      Tweet.delete_all
      csv_text = File.read('seeds/tweets.csv')
      csv_tweets = CSV.parse(csv_text, :encoding => 'ISO-8859-1')
      for i in 1...n
          row = csv_tweets[i]
          @tweet = Tweet.new(:user_id => row[0], :body => row[1], :date => row[2])
          @tweet.save
      end
  end

  def make_tweets(tweet_number,user)
      tweet_number.times do
          params = {:user_id => user.id, :body => Faker::Lorem.sentence, :date => Time.now.getutc}
          @tweet = Tweet.new(params)
          @tweet.save
      end
  end
end
