require "#{File.dirname(__FILE__)}/test_helper"

class PullerTest < Test::Unit::TestCase
  context "An authenticated default puller" do
    setup do
      $SAVER = Pork::Saver.new
      @p = Pork::Puller.new($AUTH)
      @user_info_keys = ["created_at", "description", "favourites_count", "followers_count", "following", "friends_count", "geo_enabled", "id", "location", "name", "notifications", "profile_background_color", "profile_background_image_url", "profile_background_tile", "profile_image_url", "profile_link_color", "profile_sidebar_border_color", "profile_sidebar_fill_color", "profile_text_color", "protected", "screen_name", "status", "statuses_count", "time_zone", "url", "utc_offset", "verified"]
      db_user_object = TwitterAccount.create({:twitter_id => 15019521,:screen_name => 'sam1vp'})
      @test_user = Pork::TwitterUser.new(:twitter_id => 15019521, :db_object => db_user_object)
    end
  
     should "be able to be created" do
        @p.inspect
      end  

      should "be able to pull followers for a given user" do
        @pull_hash = @p.pull(@test_user, &FOLLOWERS)
        assert_equal 22, TwitterAccount.find(TwitterRelationship.find(@pull_hash[:follower_relationship_db_ids].first).follower_id).twitter_id
        
      end

      should "be able to pull an array of follower ids for a given user_id" do
           @pull_hash = @p.pull(@test_user, &FOLLOWER_IDS)
           assert_equal @pull_hash[:follower_relationship_db_ids].class, Array
      end

       should "be able to pull friends for a given user" do
         TwitterAccount.delete_all
         @pull_hash = @p.pull(@test_user, &FRIENDS)
         assert_equal 55555, TwitterAccount.find(TwitterRelationship.find(@pull_hash[:friend_relationship_db_ids].first).friend_id).twitter_id
       end

         should "be able to pull an array of friend IDs for a given user_id" do
           @pull_hash = @p.pull(@test_user, &FRIEND_IDS)
           assert_equal @pull_hash[:friend_relationship_db_ids].class, Array
         end

         should "be able to pull tweets from a user's timeline for a given user" do
           Tweet.delete_all
           @initial_size = Tweet.all.size
           @pull_hash = @p.pull(@test_user, &TWEETS)
           assert_equal @initial_size + 6, Tweet.all.size
         end


      should "be able to pull info from twitter for a user" do
        @pull_hash = @p.pull(@test_user, &ACCOUNT_INFO)
        assert_equal @pull_hash[:pull_data].screen_name, 'sam1vp'
      end
    
  end
  context "An unauthenticated default puller" do 
    setup do 
      $SAVER = Pork::Saver.new
      @p = Pork::Puller.new()
      @user_info_keys = ["created_at", "description", "favourites_count", "followers_count", "following", "friends_count", "geo_enabled", "id", "location", "name", "notifications", "profile_background_color", "profile_background_image_url", "profile_background_tile", "profile_image_url", "profile_link_color", "profile_sidebar_border_color", "profile_sidebar_fill_color", "profile_text_color", "protected", "screen_name", "status", "statuses_count", "time_zone", "url", "utc_offset", "verified"]
      db_user_object = TwitterAccount.create({:twitter_id => 15019521,:screen_name => 'sam1vp'})
      @test_user = Pork::TwitterUser.new(:twitter_id => 15019521, :db_object => db_user_object)
    end
     should "be able to be created" do
        @p.inspect
      end  

      should "be able to pull followers for a given user" do
        @pull_hash = @p.pull(@test_user, &FOLLOWERS)
        assert_equal 22, TwitterAccount.find(TwitterRelationship.find(@pull_hash[:follower_relationship_db_ids].first).follower_id).twitter_id      
      end

      should "be able to pull an array of follower ids for a given user_id" do
           @pull_hash = @p.pull(@test_user, &FOLLOWER_IDS)
           assert_equal @pull_hash[:follower_relationship_db_ids].class, Array
      end

       should "be able to pull friends for a given user" do
         @pull_hash = @p.pull(@test_user, &FRIENDS)
         assert_equal 55555, TwitterAccount.find(TwitterRelationship.find(@pull_hash[:friend_relationship_db_ids].first).friend_id).twitter_id
       end

         should "be able to pull an array of friend IDs for a given user_id" do
           @pull_hash = @p.pull(@test_user, &FRIEND_IDS)
           assert_equal @pull_hash[:friend_relationship_db_ids].class, Array
         end

         should "be able to pull tweets from a user's timeline for a given user" do
           Tweet.delete_all
           @initial_size = Tweet.all.size
           @pull_hash = @p.pull(@test_user, &TWEETS)
           assert_equal @initial_size + 6, Tweet.all.size
         end


      should "be able to pull info from twitter for a user" do
        @pull_hash = @p.pull(@test_user, &ACCOUNT_INFO)
        assert_equal @pull_hash[:pull_data].screen_name, 'sam1vp'
      end
  end
end
