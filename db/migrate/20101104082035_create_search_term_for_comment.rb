class CreateSearchTermForComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :search_term, :string
  end

  def self.down
    remove_column :comments, :search_term
  end
end
