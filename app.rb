require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/user'
require './models/tweet'
require './models/hashtag'

enable :sessions
set :session_secret, "super secret"

get '/' do
    # @users = User.all
    # @users.each do |user|
    #     puts user.username
    #     puts user.firstname
    # end
  erb :index
end

get'/home' do
    erb :index
end

get '/signup' do
  erb :signup
end

get '/login' do
  erb :login
end

get '/success' do
  if logged_in?
      @tweets = Tweet.where(user_id: session[:user_id])
    #   @tweets.each do |tweet|
    #       puts tweet.id
    #       puts tweet.body
    #       puts tweet.user_id
    #   end
      erb :success
  else
    redirect "/login"
  end
end

get '/failure' do
  erb :failure
end

get '/logout' do
  session.clear
  redirect '/'
end

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
    redirect '/success'
  else
    redirect '/failure'
  end
end

post '/tweet' do
    @tweet = Tweet.new(:body => params[:tweet]['body'],:user_id => session[:user_id])
    if @tweet.save
      redirect '/success'
    else
      redirect '/success'
    end
end

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end
end
