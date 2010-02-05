class CreateTrends < ActiveRecord::Migration
  def self.up
    #
    create_table :trends do |t|
      t.string :name
      t.string :query
      
      t.timestamps
    end
    change_column :trends, :id, :integer, :limit => 8



  end

  def self.down
    drop_table :trends
  end
end
