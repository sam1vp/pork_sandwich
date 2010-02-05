require "#{File.dirname(__FILE__)}/pork_sandwhich/twitter_user"
require "#{File.dirname(__FILE__)}/pork_sandwhich/puller"
require "#{File.dirname(__FILE__)}/pork_sandwhich/crawler"
require "#{File.dirname(__FILE__)}/pork_sandwhich/saver"
require "#{File.dirname(__FILE__)}/pork_sandwhich/reaction_processor"
require "#{File.dirname(__FILE__)}/pork_sandwhich/auth"
require "#{File.dirname(__FILE__)}/pork_sandwhich/log"
require "#{File.dirname(__FILE__)}/pork_sandwhich/search"

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




