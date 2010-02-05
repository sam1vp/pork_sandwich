class Api < ActiveRecord::Base
  acts_as_taggable_on :tags
  has_many :calls
end