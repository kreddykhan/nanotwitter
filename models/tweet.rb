class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :hashtags

  scope :of_followed_users, -> (followed_users) { where user_id: followed_users }
end
