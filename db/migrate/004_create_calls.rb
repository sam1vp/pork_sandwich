class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.text :query
      t.float :completed_in
    
      t.integer :since_id, :limit => 8     
      t.integer :max_id, :limit => 8   
      t.string :refresh_url   
      t.integer :results_per_page 
      t.integer :next_page  
      t.integer :page 
      
      t.integer :api_id, :limit => 8
      t.timestamps      
    end
    change_column :calls, :id, :integer, :limit => 8

    # add_index :calls, :apis_id

  end

  def self.down
    drop_table :calls
  end
end
