require "#{File.dirname(__FILE__)}/test_helper"

class LogTest < Test::Unit::TestCase
  context "A default Log" do
    setup do
      @log = Pork::Log.new(STDOUT,{:researcher => "Researcher", :project => "Project"})
    end

    should "be able to be created" do
      @log.inspect
    end
  end
  
end