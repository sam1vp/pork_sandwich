class CreateConfidences < ActiveRecord::Migration
  def self.up
    #Results of googlelanguage detection
    create_table :confidences do |t|
      t.integer :twitter_account_id, :dependent => :destroy, :limit => 8
      t.integer :tweet_id, :dependent => :destroy, :limit => 8
      t.integer :language_id, :dependent => :destroy
      t.float :confidence
      t.timestamps
    end
    change_column :confidences, :id, :integer, :limit => 8
    
    # add_index :languages_tweets, [:tweets_id, :confidence]
    # add_index :languages_tweets, :languages_id

    
  end

  def self.down
    drop_table :confidences
  end
end
