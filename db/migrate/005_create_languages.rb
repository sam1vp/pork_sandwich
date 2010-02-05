class CreateLanguages < ActiveRecord::Migration
  def self.up
    #Languages is a static associaltion of Full language name to iso codes returned by language detection
    create_table :languages do |t|
      t.string :english_name_of_language
      t.string :iso_639_1
      t.string :iso_639_2
      t.string :iso_639_2_bibliographical
      t.string :iso_639_2_terminology
      
    end
    # add_index :languages, :english_name_of_language

  end

  def self.down
    drop_table :languages
  end
end
