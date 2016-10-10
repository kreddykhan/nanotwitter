class Tweet < ActiveRecord::Base
  belongs_to_only_one :user
  has_many :hashtags
end
