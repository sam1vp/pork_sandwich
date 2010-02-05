class CreateReactions < ActiveRecord::Migration
  def self.up
    #static list of what kind of relationships can exist and their numeric id's
    create_table :reactions do |t|
      t.string :reaction_type, :limit => 20
      t.float :value
    end
    # add_index :trends_twitter_accounts, :twitter_accounts_id
    # add_index :trends_twitter_accounts, :trends_id
    
  end

  def self.down
    drop_table :reactions
  end
end
