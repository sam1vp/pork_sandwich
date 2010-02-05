class CreateTrendsTweets < ActiveRecord::Migration
  def self.up
    create_table :trends_tweets, :id => false  do |t|
      t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :trend_id, :null => false, :dependent => :destroy, :limit => 8
    end
    # add_index :trends_tweets, :tweets_id
    # add_index :trends_tweets, :trends_id


  end

  def self.down
    drop_table :trends_tweets
  end
end
