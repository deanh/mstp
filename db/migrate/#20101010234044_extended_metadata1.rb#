class ExtendedMetadata1 < ActiveRecord::Migration
  def self.up
    add_column :users, :url, :string
    add_column :comments, :user_id, :integer
    add_column :comments, :twitter_handle, :string
    add_column :comments, :twitter_response_to, :string
  end

  def self.down
    remove_column :users, :url
    remove_column :comments, :user_id
    remove_column :comments, :twitter_handle
    remove_column :comments, :twitter_response_to
    drop_table :comments
    drop_table :users
    
  end
end
