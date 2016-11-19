require 'rubygems'
require 'faker'
require './models/relationship'

User.delete_all
Tweet.delete_all

10.times do
    first_name = Faker::Name.first_name
    params = {:username => first_name, :password => 'test', :firstname => first_name, :lastname => Faker::Name.last_name, :email => Faker::Internet.email(first_name), :birthday => Faker::Date.backward(20)}
    @user = User.new(params)
    @user.save
end

@users = User.all
@users.each do |user|
    100.times do
        params = {:user_id => user.id, :body => Faker::Lorem.sentence}
        @tweet = Tweet.new(params)
        @tweet.save
    end
    20.times do
        @user2 = @users.sample
        user.followed << @user2
    end
end
