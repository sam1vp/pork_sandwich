class CreateCallsTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :calls_twitter_accounts, :id => false do |t|
      t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :twitter_account_id, :null => false, :dependent => :destroy, :limit => 8
    end
    # add_index :calls_twitter_accounts, :calls_id
    # add_index :calls_twitter_accounts, :twitter_accounts_id


  end

  def self.down
    drop_table :calls_twitter_accounts
  end
end
