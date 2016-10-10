class User < ActiveRecord::Base

  has_secure_password
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  has_many :tweets
  # has_many followers

end
