class CreateCallsTweets < ActiveRecord::Migration
  def self.up
    create_table :calls_tweets, :id => false do |t|
      t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
    end
    # add_index :calls_tweets, :calls_id
    # add_index :calls_tweets, :tweets_id


  end

  def self.down
    drop_table :calls_tweets
  end
end
