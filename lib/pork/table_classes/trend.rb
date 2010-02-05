class Trend < ActiveRecord::Base
  acts_as_taggable_on :tags
  has_and_belongs_to_many :calls
  has_and_belongs_to_many :tweets  
  has_and_belongs_to_many :twitter_accounts  
end
