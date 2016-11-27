class AddIndexUniquenessToRelationships < ActiveRecord::Migration
  def change
      Tweet.destroy_all
      Relationship.destroy_all
      User.destroy_all

      ActiveRecord::Base.connection.tables.each do |t|
          ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
      add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
