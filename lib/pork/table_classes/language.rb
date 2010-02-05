class Language < ActiveRecord::Base
  has_many :confidences, :dependent => :destroy
  has_many :twitter_accounts, :through => :confidences
  has_many :tweets, :through => :confidences
end
