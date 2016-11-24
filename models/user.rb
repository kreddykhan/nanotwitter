class User < ActiveRecord::Base

  has_secure_password
  # validates_uniqueness_of :email
  # validates_uniqueness_of :username

  has_many :tweets

  # has many relationships through a foreign key which is a follower_id number
  has_many :relationships, foreign_key: :follower_id
  # has many people they are following through the relationships table entries
  has_many :followed, through: :relationships, source: :followed

  # has many relationships through a foreign key which is the followed_id number of the Relationship class
  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship'
  # has many followers through the relationships
  has_many :followers, through: :reverse_relationships, source: :follower

  def follow!(user)
      followed << user
  end

end
