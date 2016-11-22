class User < ActiveRecord::Base

  has_secure_password
  # validates_uniqueness_of :email
  # validates_uniqueness_of :username

  has_many :tweets

  has_many :relationships, foreign_key: :follower_id
  has_many :followed, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship'
  has_many :followers, through: :reverse_relationships, source: :follower

  def follow!(user)
      followed << user
  end

end
