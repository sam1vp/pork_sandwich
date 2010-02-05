class CreateRelationshipSetColumns < ActiveRecord::Migration
  def self.up
    add_column :twitter_relationships, :complete_follower_set, :boolean, :default => false
    add_column :twitter_relationships, :complete_friend_set, :boolean, :default => false
  end

  def self.down
    remove_column :twitter_relationships, :complete_follower_set
    remove_column :twitter_relationships, :complete_friend_set
  end

end