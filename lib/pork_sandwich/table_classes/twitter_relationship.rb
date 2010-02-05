class TwitterRelationship < ActiveRecord::Base
  acts_as_taggable_on :tags, :relationships
  
  belongs_to :friend, :class_name => "TwitterAccount"
  belongs_to :follower, :class_name => "TwitterAccount"  
end
