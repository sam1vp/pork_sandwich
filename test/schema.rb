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
    t.datetime :time_of_user_creation
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
    t.datetime :time_of_tweet
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

  create_table :apis do  |t|
    t.string :domain
    t.string :name
    t.text :description
    t.string :documentation_url
    
    t.string :username
    t.string :password
    t.timestamps
  end

  create_table :calls do  |t|
    t.text :query
    t.float :completed_in
  
    t.integer :since_id, :limit => 8     
    t.integer :max_id, :limit => 8   
    t.string :refresh_url   
    t.integer :results_per_page 
    t.integer :next_page  
    t.integer :page 
    
    t.integer :api_id, :limit => 8
    t.timestamps      
  end
    
  create_table :languages do  |t|
    t.string :english_name_of_language
    t.string :iso_639_1
    t.string :iso_639_2
    t.string :iso_639_2_bibliographical
    t.string :iso_639_2_terminology
    
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
    t.timestamps      
  end

  create_table :confidences do  |t|
    t.integer :twitter_account_id, :dependent => :destroy, :limit => 8
    t.integer :tweet_id, :dependent => :destroy, :limit => 8
    t.integer :language_id, :dependent => :destroy
    t.float :confidence
    t.timestamps
  end

  create_table :calls_twitter_accounts, :id => false do |t|
    t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :twitter_account_id, :null => false, :dependent => :destroy, :limit => 8
  end

  create_table :calls_tweets, :id => false do |t|
    t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
  end

  create_table :calls_trends, :id => false  do |t|
    t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
    t.integer :trend_id, :null => false, :dependent => :destroy, :limit => 8
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