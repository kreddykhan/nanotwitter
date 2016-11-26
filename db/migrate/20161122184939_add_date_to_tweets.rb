class AddDateToTweets < ActiveRecord::Migration
  def change
      add_column :tweets, :date, :datetime
  end

  def drop
      execute "DROP TABLE #{:users} CASCADE"
      execute "DROP TABLE #{:relationships} CASCADE"
      execute "DROP TABLE #{:tweets} CASCADE"
  end
end
