require "#{File.dirname(__FILE__)}/test_helper"

class LogTest < Test::Unit::TestCase
  context "A default Log" do
    setup do
      @log = Pork::Log.new('testlog.txt',{:researcher => "Researcher", :project => "Project"})
    end

    should "be able to be created" do
      @log.inspect
    end
    
    should 'be able to write to the specified log file' do
      @log.write("testing123")
      log_string = ""
      File.open('testlog.txt','r').each do |line|
        log_string << line
      end
      assert log_string.include? ("testing123")
      assert log_string.include? ("Project, Researcher")
    end
    
    teardown do 
      File.delete('testlog.txt')
    end
  end
  
end