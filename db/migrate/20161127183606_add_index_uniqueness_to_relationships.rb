class AddIndexUniquenessToRelationships < ActiveRecord::Migration
  def change
      add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
