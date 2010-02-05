class CreateTrendsTwitterAccounts < ActiveRecord::Migration
# Relates what users(twitter_account_id) have participated in which trends(trend_id)
  def self.up
    create_table :trends_twitter_accounts, :id => false  do |t|
      t.integer :trend_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :twitter_account_id, :null => false, :dependent => :destroy, :limit => 8
    end
    # add_index :trends_twitter_accounts, :twitter_accounts_id
    # add_index :trends_twitter_accounts, :trends_id


  end

  def self.down
    drop_table :trends_twitter_accounts
  end
end
