class CreateTags < ActiveRecord::Migration
  def self.up
    #Create associations between tag names and the strings used everywhere else
    create_table :tags do |t|
      t.column :name, :string
    end
    
    #Documents and loggs tags to tweets
    # XXX fill more documentation here XXX
    create_table :taggings do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      t.column :tagger_id, :integer
      t.column :tagger_type, :string
      
      t.column :taggable_type, :string
      t.column :context, :string
      
      t.column :created_at, :datetime
    end
    
    # add_index :taggings, :tag_id
    # add_index :taggings, [:taggable_id, :taggable_type, :context]



  end
  
  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
