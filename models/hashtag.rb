class Hashtag < ActiveRecord::Base
  belongs_to_many :tweets
end
