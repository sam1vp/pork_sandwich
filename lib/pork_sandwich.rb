require "#{File.dirname(__FILE__)}/pork_sandwich/twitter_user"
require "#{File.dirname(__FILE__)}/pork_sandwich/puller"
require "#{File.dirname(__FILE__)}/pork_sandwich/crawler"
require "#{File.dirname(__FILE__)}/pork_sandwich/saver"
require "#{File.dirname(__FILE__)}/pork_sandwich/reaction_processor"
require "#{File.dirname(__FILE__)}/pork_sandwich/auth"
require "#{File.dirname(__FILE__)}/pork_sandwich/log"
require "#{File.dirname(__FILE__)}/pork_sandwich/search"


module Pork 
  require 'twitter'
  #Object.send :undef_method, :id

  
  ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
  ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger
  
end




