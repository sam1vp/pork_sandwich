class CreateApis < ActiveRecord::Migration
  def self.up
    create_table :apis do |t|
      t.string :domain
      t.string :name
      t.text :description
      t.string :documentation_url
      
      t.string :username
      t.string :password
      t.timestamps
    end
    # add_index :apis, :domain    
  end

  def self.down
    drop_table :apis
  end
end