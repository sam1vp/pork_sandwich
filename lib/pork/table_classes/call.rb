class Call < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :api
  has_and_belongs_to_many :trends  
  has_and_belongs_to_many :tweets  
  has_and_belongs_to_many :twitter_accounts 
end
