class ChangeToTimestampWithTimezone < ActiveRecord::Migration
  def self.up
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
  end

  def self.down
    execute "alter table tweets " +
    "alter column time_of_tweet type timestamp without time zone;"
    execute "alter table tweets " +  
    "alter column created_at type timestamp without time zone;"
    execute "alter table tweets " +  
    "alter column updated_at type timestamp without time zone;"
    execute "alter table twitter_accounts " +  
    "alter column time_of_user_creation type timestamp without time zone;"
    execute "alter table twitter_accounts " +  
    "alter column created_at type timestamp without time zone;"
    execute "alter table twitter_accounts " +  
    "alter column updated_at type timestamp without time zone;"
    execute "alter table taggings " +  
      "alter column created_at type timestamp without time zone;"
    execute "alter table trends " +  
    "alter column created_at type timestamp without time zone;"
    execute "alter table trends " +  
    "alter column updated_at type timestamp without time zone;"
    execute "alter table tweet_reactions " +  
    "alter column created_at type timestamp without time zone;"
    execute "alter table tweet_reactions " +  
    "alter column updated_at type timestamp without time zone;"
  end

end
