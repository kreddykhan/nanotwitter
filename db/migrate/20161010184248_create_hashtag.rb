class CreateHashtag < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :body
      t.integer :tweet_id
      t.timestamp
    end
  end

  def drop
    drop_table :hashtags
  end
end
