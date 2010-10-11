class AddUidToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :uid, :string
    add_column :comments, :source, :string
  end

  def self.down
#    remove_column :comments, :uid
#    remove_column :comments, :source
  end
end
