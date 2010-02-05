class CreateTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :twitter_accounts do |t|
      t.integer :twitter_id, :limit => 8
      t.integer :twitter_id_for_search, :limit => 8
      t.string :screen_name, :null => false 
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

#could also store "following" which would track whether the account that performed the search is following the given user       
      t.timestamps
    end
    change_column :twitter_accounts, :id, :integer, :limit => 8
    # add_index :twitter_accounts, :twitter_id
    # add_index :twitter_accounts, :twitter_id_for_search    
    # add_index :twitter_accounts, :screen_name
    # add_index :twitter_accounts, :created_at


  end

  def self.down
    drop_table :twitter_accounts
  end
end
