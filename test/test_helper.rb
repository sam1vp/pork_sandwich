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

Object.send :undef_method, :id

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  config = YAML::load(File.open("#{File.dirname(__FILE__)}/../config/pork_config.yml"))
  $AUTH = Pork::Auth.new(config['config']['twitter_auth']['username'], config['config']['twitter_auth']['password'], :user_agent => 'web_ecology_project')
  reaction_types = ['retweet', 'mention', 'reply']
  reaction_types.each do |r|
    unless Reaction.find_by_reaction_type(r)
      Reaction.create(:reaction_type => r)
    end
  end
end












