class CreateDataAgain < ActiveRecord::Migration
  def change
      drop_table :users
      drop_table :tweets
      drop_table :relationships
      
      create_table :users do |t|
          t.string :username
          t.string :password_digest
          t.string :firstname
          t.string :lastname
          t.string :email
          t.date :birthday
          t.timestamps
      end

      create_table :tweets do |t|
        t.string :body
        t.integer :user_id
        t.datetime :date
        t.timestamps
      end

      create_table :relationships do |t|
          t.integer :follower_id
          t.integer :followed_id
          t.timestamps
      end
  end

  def drop
      execute "DROP SCHEMA schema"
  end
end
