class CreateUser < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :firstname
      t.string :lastname
      t.string :email
      t.date :birthday
      t.timestamp
    end
  end

  def down
    drop_table :users
  end
end
