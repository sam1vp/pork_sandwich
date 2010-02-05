class TwitterAccount < ActiveRecord::Base
  acts_as_taggable_on :tags
  has_many :tweets
  has_and_belongs_to_many :trends
  
  
  has_many :tweet_reactions
  
  has_many :initiations, :foreign_key => 'initiator_id',
                         :class_name => 'TweetReaction',
                         :dependent => :destroy
  has_many :initiators, :through => :initiations                       
  
  has_many :responses, :foreign_key => 'responder_id',
                         :class_name => 'TweetReaction',
                         :dependent => :destroy
  has_many :responders, :through => :responses

  has_many :friendships, :foreign_key => 'friend_id',
                          :class_name => 'TwitterRelationship',
                          :dependent => :destroy 
  has_many :friends, :through => :followerships
                          
  has_many :followerships, :foreign_key => 'follower_id',
                          :class_name => 'TwitterRelationship',
                          :dependent => :destroy
  has_many :followers, :through => :friendships     
  
end
