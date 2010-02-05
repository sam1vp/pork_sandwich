require 'rubygems'
require 'test/unit'
require 'fakeweb'
require 'shoulda'
require 'factory_girl'
require "#{File.dirname(__FILE__)}/schema"
require 'twitter'
require "#{File.dirname(__FILE__)}/fakewebs"
require 'rr'




require "#{File.dirname(__FILE__)}/../lib/pork_sandwich"

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  config = YAML::load(File.open("#{File.dirname(__FILE__)}/../config/pork_config.yml"))
  $AUTH = Pork::Auth.new(config['config']['twitter_auth']['username'], config['config']['twitter_auth']['password'], :user_agent => 'web_ecology_project').auth
end












