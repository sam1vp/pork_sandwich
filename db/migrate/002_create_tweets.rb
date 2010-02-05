class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.text :text, :null => false
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
    change_column :tweets, :id, :integer, :limit => 8

    # add_index :tweets, :text
    #   add_index :tweets, :from_user
    #   add_index :tweets, :from_user_id_search    
    #   add_index :tweets, :status_id        
    #   add_index :tweets, :created_at

  end
  
  def self.down
    drop_table :tweets
  end
end
