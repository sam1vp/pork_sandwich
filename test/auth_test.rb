require "#{File.dirname(__FILE__)}/test_helper"

class AuthTest < Test::Unit::TestCase
  context "An Auth object" do
    setup do
      @auth = Pork::Auth.new("username", "password", "user_agent")
    end

    should "be able to be created" do
      assert_equal "username", @auth.auth.client.username
      assert_equal "password", @auth.auth.client.password
      assert_equal "user_agent", @auth.auth.client.options[:user_agent]
    end
  end
  
end