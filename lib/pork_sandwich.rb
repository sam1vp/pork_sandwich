require "#{File.dirname(__FILE__)}/pork_sandwich/twitter_user"
require "#{File.dirname(__FILE__)}/pork_sandwich/puller"
require "#{File.dirname(__FILE__)}/pork_sandwich/crawler"
require "#{File.dirname(__FILE__)}/pork_sandwich/saver"
require "#{File.dirname(__FILE__)}/pork_sandwich/reaction_processor"
require "#{File.dirname(__FILE__)}/pork_sandwich/auth"
require "#{File.dirname(__FILE__)}/pork_sandwich/log"
require "#{File.dirname(__FILE__)}/pork_sandwich/search"

require "#{File.dirname(__FILE__)}/pork/table_classes/reaction"
require "#{File.dirname(__FILE__)}/pork/table_classes/trend"
require "#{File.dirname(__FILE__)}/pork/table_classes/tweet"
require "#{File.dirname(__FILE__)}/pork/table_classes/tweet_reaction"
require "#{File.dirname(__FILE__)}/pork/table_classes/twitter_account"
require "#{File.dirname(__FILE__)}/pork/table_classes/twitter_relationship"

module Pork 
  #Object.send :undef_method, :id

  
  ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
  ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger
  
end




