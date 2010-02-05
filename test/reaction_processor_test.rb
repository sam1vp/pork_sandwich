require "#{File.dirname(__FILE__)}/test_helper"

class ReactionProcessorTest < Test::Unit::TestCase
  context "A default saver" do
    setup do
      db_user_object = TwitterAccount.create({:twitter_id => 15019521,:screen_name => 'sam1vp'})
      @processor = Pork::ReactionProcessor.new(Pork::TwitterUser.new(:twitter_id => 15019521, :db_object=> db_user_object))
    end
    should "be able to be created" do 
      @processor.inspect
    end
    context "given a tweet with '@username ...'" do
      tweet = Factory.build(:reply_tweet)
      should "be able to extract a reply screen_name" do 
        assert_equal "username", @processor.parse_tweet_for_influentials(tweet)[:reply_screen_name]
      end
    end
    context "given a tweet with '... @username ...'" do
      tweet = Factory.build(:mention_tweet)
      should "be able to extract a mention screen_name" do 
        assert_equal "username", @processor.parse_tweet_for_influentials(tweet)[:mention_screen_names].first
      end
    end
    context "given a tweet with 'RT @username ...'" do
      tweet = Factory.build(:retweet1_tweet)
      should "be able to extract a retweet influential" do 
        assert_equal "username", @processor.parse_tweet_for_influentials(tweet)[:rt_screen_names].first
      end
    end
    context "given a tweet with '...RT @username ...'" do
      tweet = Factory.build(:retweet2_tweet)
      should "be able to extract a retweet influential" do 
        assert_equal "username", @processor.parse_tweet_for_influentials(tweet)[:rt_screen_names].first
      end
    end
    context "given a tweet with '...@username...@username...'" do
      tweet = Factory.build(:double_mention_tweet)
      should "be able to extract a two mention influential" do 
        assert_equal "username1", @processor.parse_tweet_for_influentials(tweet)[:mention_screen_names].first
        assert_equal "username2", @processor.parse_tweet_for_influentials(tweet)[:mention_screen_names].last
      end
    end
  end

end

