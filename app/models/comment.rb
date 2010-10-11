class Comment < ActiveRecord::Base
  acts_as_tree :order => 'created_at'
  belongs_to :user

  def descendants
    children.map(&:descendants).flatten + children
  end
end
