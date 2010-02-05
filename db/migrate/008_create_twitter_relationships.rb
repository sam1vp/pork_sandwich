class CreateTwitterRelationships < ActiveRecord::Migration
  def self.up
    # Friend relationships or 'edges'
    create_table :twitter_relationships do |t|
      t.integer :follower_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :friend_id, :null => false, :dependent => :destroy, :limit => 8
      t.boolean :current
      t.timestamps      
    end
    change_column :twitter_relationships, :id, :integer, :limit => 8

    # add_index :twitter_relationships, [:follower_id, :current]
    # add_index :twitter_relationships, [:friend_id, :current]

  end

  def self.down
    drop_table :twitter_relationships
  end
end
