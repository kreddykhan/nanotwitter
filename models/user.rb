class User < ActiveRecord::Base

  has_secure_password
  # validates_uniqueness_of :email
  # validates_uniqueness_of :username

  has_many :tweets

  has_many :relationships, foreign_key: :follower_id
  has_many :followed, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship'
  has_many :followers, through: :reverse_relationships, source: :follower

  # has_many :followers, through: :follower_follows, source: :follower
  # has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow"
  #
  # has_many :followees, through: :followee_follows, source: :followee
  # has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow"

  def follow!(user)
      followed << user
  end

end
