class Comment < ActiveRecord::Base
  acts_as_tree :order => 'created_at'
  validates_uniqueness_of :uid
end
