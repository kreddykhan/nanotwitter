require 'rubygems'
require 'faker'
require './app.rb'
require './models/relationship'
require 'csv'

# User.delete_all
# Tweet.delete_all
# Relationship.delete_all
# Tweet.destroy_all
# Relationship.destroy_all
# User.destroy_all

# ActiveRecord::Base.connection.execute("DROP TABLE #{:users} CASCADE")
# ActiveRecord::Base.connection.execute("DROP TABLE #{:relationships} CASCADE")
# ActiveRecord::Base.connection.execute("DROP TABLE #{:tweets} CASCADE")
# ActiveRecord::Base.connection.execute("TRUNCATE tweets")
# ActiveRecord::Base.connection.execute("TRUNCATE relationships")
# ActiveRecord::Base.connection.execute("TRUNCATE users")

csv_text = File.read('seeds/users.csv')
csv_user = CSV.parse(csv_text, :encoding => 'ISO-8859-1')
csv_user.each do |row|
    @user = User.new(:id => row[0], :username => row[1], :password => 'test', :firstname => row[1], :lastname => Faker::Name.last_name, :email => Faker::Internet.email(row[1]), :birthday => Faker::Date.backward(20))
    @user.save
end

csv_text = File.read('seeds/follows.csv')
csv_followers = CSV.parse(csv_text, :encoding => 'ISO-8859-1')
csv_followers.each do |row|
    @user1 = User.find(row[0])
    @user2 = User.find(row[1])
    @user1.followed << @user2
end

csv_text = File.read('seeds/tweets.csv')
csv_tweets = CSV.parse(csv_text, :encoding => 'ISO-8859-1')
csv_tweets.each do |row|
    @tweet = Tweet.new(:user_id => row[0], :body => row[1], :date => row[2])
    @tweet.save
end

puts "There are now #{User.count} rows in the user table"
puts "There are now #{Relationship.count} rows in the relationship table"
puts "There are now #{Tweet.count} rows in the tweet table"
