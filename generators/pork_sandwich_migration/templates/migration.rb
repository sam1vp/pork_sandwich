class PorkSandwichMigration < ActiveRecord::Migration
  def self.up
    create_table :twitter_accounts do |t|
      t.integer :twitter_id, :limit => 8
      t.integer :twitter_id_for_search, :limit => 8
      t.string :screen_name
      t.string :name 
      t.string :location
      t.datetime :time_of_user_creation 
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

    begin
      execute "alter table tweets " +  
      "alter column time_of_tweet type timestamp with time zone;"
      execute "alter table tweets " +  
      "alter column created_at type timestamp with time zone;"
      execute "alter table tweets " +  
      "alter column updated_at type timestamp with time zone;"  
      execute "alter table twitter_accounts " +  
      "alter column time_of_user_creation type timestamp with time zone;"
      execute "alter table twitter_accounts " +  
      "alter column created_at type timestamp with time zone;"
      execute "alter table twitter_accounts " +  
      "alter column updated_at type timestamp with time zone;"  
      execute "alter table taggings " +  
        "alter column created_at type timestamp with time zone;"
      execute "alter table trends " +  
      "alter column created_at type timestamp with time zone;"
      execute "alter table trends " +  
      "alter column updated_at type timestamp with time zone;"
      execute "alter table tweet_reactions " +  
      "alter column created_at type timestamp with time zone;"
      execute "alter table tweet_reactions " +  
      "alter column updated_at type timestamp with time zone;"
    rescue SQLException => e
      puts e + "\n" + "Migration failed to change timestamp column data types pork_sandwich tables. Attempted to change all timestamp without time zone types to timestamp with time zone types. Tables will still properly process and store time zone data for timestamps, but will not export UTC offset on COPY to." 
    end
  reaction_types = ['retweet', 'mention', 'reply']
  reaction_types.each do |r|
    unless Reaction.find_by_reaction_type(r)
      Reaction.create(:reaction_type => r)
    end
  end  
    
  end

  def self.down
    drop_table :twitter_accounts 
    drop_table :tweets
    drop_table :trends
    drop_table :tags
    drop_table :taggings
    drop_table :twitter_relationships
    drop_table :trends_tweets
    drop_table :trends_twitter_accounts
    drop_table :reactions
    drop_table :tweet_reactions
  end
end