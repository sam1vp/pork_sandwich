require 'active_record'
require 'acts-as-taggable-on'

#Include modules from acts_as_taggable_on
ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger

#Setup connection to db and logging
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
#ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))


ActiveRecord::Schema.define(:version => 0) do 
  create_table :twitter_accounts do |t|
    t.integer :twitter_id, :limit => 8
    t.integer :twitter_id_for_search, :limit => 8
    t.string :screen_name
    t.string :name 
    t.string :location

    t.datetime :time_of_user_creation #need timezone
    
    t.text :description
    t.string :profile_image_url
    t.string :url
    t.boolean :protected
    t.integer :followers_count
    t.string :profile_background_color
    t.string :profile_text_color
    t.string :profile_link_color
    t.string :profile_sidebar_fill_color
    t.string :profile_sidebar_border_color
    t.integer :friends_count
    t.integer :favourites_count
    t.integer :utc_offset
    t.string :time_zone
    t.string :profile_background_image_url
    t.boolean :profile_background_tile
    t.integer :statuses_count
    t.boolean :notifications
    t.boolean :verified
    t.timestamps
  end
  
  create_table :tweets do |t|
    t.string :text, :null => false
    t.datetime :time_of_tweet #need timestamp
    t.string :from_user, :null => false
    t.integer :to_user_id
    t.integer :to_user_id_search
    t.string :to_user      
    t.integer :status_id, :null => false, :limit => 8       
    t.integer :from_user_id_search, :limit => 8 
    t.string :iso_language_code
    t.string :source
    t.string :profile_image_url
    t.integer :twitter_account_id, :limit => 8
    t.boolean :truncated

    t.timestamps
  end

  create_table :trends do  |t|
    t.string :topic    
    t.timestamps
  end

  create_table :tags do  |t|
    t.column :name, :string
  end
  
  create_table :taggings do  |t|
    t.column :tag_id, :integer
    t.column :taggable_id, :integer
    t.column :tagger_id, :integer
    t.column :tagger_type, :string
    
    t.column :taggable_type, :string
    t.column :context, :string
    
    t.column :created_at, :datetime
  end

  create_table :twitter_relationships do  |t|
    t.integer :follower_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :friend_id, :null => false, :dependent => :destroy, :limit => 8
    t.boolean :current
    t.boolean :complete_follower_set
    t.boolean :complete_friend_set
    t.timestamps      
  end


  create_table :trends_tweets, :id => false  do |t|
    t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :trend_id, :null => false, :dependent => :destroy, :limit => 8
  end

  create_table :trends_twitter_accounts, :id => false  do |t|
    t.integer :trend_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :twitter_account_id, :null => false, :dependent => :destroy, :limit => 8
  end

  create_table :reactions do  |t|
    t.string :reaction_type, :limit => 20
    t.float :value
  end

  create_table :tweet_reactions do |t|
    t.integer :initiator_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :responder_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
    t.references :reaction
    t.boolean :current
    t.timestamps            
  end
end

class Reaction < ActiveRecord::Base
  has_many :tweet_reactions
end

class TwitterRelationship < ActiveRecord::Base
  acts_as_taggable_on :tags, :relationships
  
  belongs_to :friend, :class_name => "TwitterAccount"
  belongs_to :follower, :class_name => "TwitterAccount"  
end


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

class TweetReaction < ActiveRecord::Base
  acts_as_taggable_on :tags
  
  belongs_to :tweet
  belongs_to :initiator, :class_name => "TwitterAccount"
  belongs_to :responder, :class_name => "TwitterAccount"  
  belongs_to :reaction
end

class Tweet < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :twitter_account 
  has_and_belongs_to_many :trends  
  
  has_many :tweet_reactions
  
end

class Trend < ActiveRecord::Base
  acts_as_taggable_on :tags
  has_and_belongs_to_many :tweets  
  has_and_belongs_to_many :twitter_accounts  
end
