class CreateTweet < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :body
      t.integer :user_id
      t.timestamp
    end
  end

  def drop
    drop_table :tweets
  end
end
