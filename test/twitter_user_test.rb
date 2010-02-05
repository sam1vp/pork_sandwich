require "#{File.dirname(__FILE__)}/test_helper"

class TwitterUserTest < Test::Unit::TestCase
  context "A TwitterUser with 'full' attributes" do
    setup do
      @user = Pork::TwitterUser.new({:twitter_id => 15019521, :twitter_screen_name => 'user_name', :crawled => true, :user_info => 'user_info', :db_object => 'db_object'})
      
    end

    should "be able to reveal its twitter_id" do
      assert_equal 15019521, @user.twitter_id
    end
    should "be able to reveal its screen_name" do
      assert_equal 'user_name', @user.twitter_screen_name
    end
    should "be able to reveal its crawl status " do
      assert_equal true, @user.crawled
    end
    should "be able to reveal its user info " do
      assert_equal 'user_info', @user.user_info
    end
    should "be able to reveal its db object" do
      assert_equal 'db_object', @user.db_object
    end
    
    should "not be able to update user data with the pull user data method" do
      @user.pull_account_info
      assert_equal 'user_info', @user.user_info
      assert_equal 'user_name', @user.twitter_screen_name
    end
    
    should "be able to update user data" do
      @user.update_account_info
      assert_equal 'Sam Gilbert', @user.user_info[:name]
      assert_equal 'sam1vp', @user.twitter_screen_name
    end
    
    should "be able to pull tweets" do
      @user.pull_tweets
      assert_equal 5590958294, Tweet.find(@user.tweet_db_ids[1]).status_id
    end
    
    should "be able to pull followers" do
      @user.pull_followers
      assert_equal @user.db_object.id, TwitterRelationship.find(@user.follower_relationship_db_ids[3]).friend_id
    end
    
    should "be able to pull friends" do
      @user.pull_friends
      assert_equal @user.db_object.id, TwitterRelationship.find(@user.friend_relationship_db_ids[3]).follower_id
    end
    
    should "be able to pull friend_ids" do 
      @user.pull_friend_ids
      assert_equal @user.db_object.id, TwitterRelationship.find(@user.friend_relationship_db_ids.first).follower_id
    end
    
    should "be able to pull follower_ids" do 
      @user.pull_follower_ids
      assert_equal @user.db_object.id, TwitterRelationship.find(@user.follower_relationship_db_ids.first).friend_id
    end
    
    
  end
  
end