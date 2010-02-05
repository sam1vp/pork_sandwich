require "#{File.dirname(__FILE__)}/pork/twitter_user"
require "#{File.dirname(__FILE__)}/pork/puller"
require "#{File.dirname(__FILE__)}/pork/crawler"
require "#{File.dirname(__FILE__)}/pork/saver"
require "#{File.dirname(__FILE__)}/pork/reaction_processor"
require "#{File.dirname(__FILE__)}/pork/auth"
require "#{File.dirname(__FILE__)}/pork/log"
require "#{File.dirname(__FILE__)}/pork/search"

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




