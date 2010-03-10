require "#{File.dirname(__FILE__)}/test_helper"

class SearchTest < Test::Unit::TestCase
  context "A search object with query, desired_count, and from_user" do
    setup do
      @search = Pork::Search.new('test', {:from_user => "from_user", :desired_count => 1})
    end

    should "let me read query" do
      assert_equal "test", @search.query
    end
    
    should "let me read count" do
      assert_equal 1, @search.desired_count
    end
    
    should "let me read from_user" do
      assert_equal "from_user", @search.from_user
    end
    
    should "let me read db_ids_created" do
      assert_equal [], @search.db_ids_created
    end
    
  end
  context "A search object where query = 'test'" do
    setup do
      @search = Pork::Search.new('test')
    end

    should "be able to do an historical pull" do
      result = @search.historical_pull
      assert_equal true, result
      assert_equal 5, @search.current_count
    end
    context "and desired_count = 2" do
      setup do
        @search = Pork::Search.new('test', {:desired_count => 4})
      end

      should "be able to do an historical pull for only 4 tweets" do
        result = @search.historical_pull
        assert_equal true, result
        assert_equal 4, @search.current_count
      end
    end
    context "and since_id = 5624809937" do 
      setup do 
        @search = Pork::Search.new('test', {:since_id => 5624809937})
      end
      should "be able to do an historical pull for only 1 tweet (because the second tweet id will = 5624809937)" do
        result = @search.historical_pull
        assert_equal true, result
        assert_equal 1, @search.current_count
      end
    end
  end
  
end