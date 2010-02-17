require "#{File.dirname(__FILE__)}/test_helper"

class SaverTest < Test::Unit::TestCase
  context "A default saver" do
    setup do
      @saver = Pork::Saver.new
    end
    # context "when saving a unique tweet" do
    #   setup do
    #     @tweet_size = Tweet.all.size
    #     @tweet = Factory.build(:tweet)
    #     @saver.save(@tweet, &TWEET_SAVE)
    #   end
    #   should "allow the tweet to be saved" do
    #       assert_equal @tweet_size+1, Tweet.all.size
    #   end
    # end
    context "when saving a unique user" do
      setup do
        @twitter_account_size = TwitterAccount.all.size
        @twitter_account = Factory.build(:twitter_account)
        @saver.save(@twitter_account, &TWITTER_ACCOUNT_SAVE)        
      end
    
      should "allow the user to be saved" do
        assert_equal @twitter_account_size+1, TwitterAccount.all.size
      end
    end
  
    context "when saving a relationship" do
      setup do
        @twitter_relationship_size = TwitterRelationship.all.size
        @friend = Pork::TwitterUser.new(:db_object => Factory.create(:twitter_account))
        @follower = Pork::TwitterUser.new(:db_object => Factory.create(:twitter_account))
        @saver.save(:friend => @friend, :follower => @follower, &RELATIONSHIP_SAVE)        
      end
    
      should "allow the relationship to be saved" do
        assert_equal @twitter_relationship_size+1, TwitterRelationship.all.size
      end
    end
    context "when saving a tweet_reaction" do
      setup do
        @tweet_reaction_size = TweetReaction.all.size
        @tweet_reaction = {:tweet => Factory.create(:tweet),:initiator => Factory.create(:twitter_account), :responder => Factory.create(:twitter_account), :type => 'retweet'} 
      end
    
      should "allow the reaction to be saved" do
        @saver.save(@tweet_reaction, &REACTION_SAVE)  
        assert_equal @tweet_reaction_size+1, TweetReaction.all.size
      end
    end
    
  end


  context "A saver with taggings" do
    setup do
      @rules = {:check_validation => false, :create_relationships => false, :language_detect => false, "tags" => {"tag" => "tag1"}}
      @saver = Pork::Saver.new(rules = @rules)
    end
  #   context "when saving a unique tweet" do
  #     setup do
  #       @tweet = Factory.build(:tweet)
  #       @saver.save(@tweet, &TWEET_SAVE)
  #     end
  #     
  #     should "have the tag soved on the tweet" do
  #       assert_contains Tweet.find_by_status_id(@tweet.status_id).tag_list, @rules["tags"]["tag"]        
  #     end
  #   end

    context "when saving a unique user" do
      setup do
        @twitter_account = Factory.build(:twitter_account)
        @saver.save(@twitter_account, &TWITTER_ACCOUNT_SAVE)        
      end
    
      should "allow the user to be tagged" do
        assert_contains TwitterAccount.find_by_screen_name(@twitter_account.screen_name).tag_list, @rules["tags"]["tag"]            
      end
    end
 
     context "when saving a relationship" do
      setup do
        @friend = Pork::TwitterUser.new(:db_object => Factory.create(:twitter_account))
        @follower = Pork::TwitterUser.new(:db_object => Factory.create(:twitter_account))
        @saver.save(:friend => @friend, :follower => @follower, &RELATIONSHIP_SAVE)        
      end
    
      should "allow the relationship to be tagged" do
        assert_contains TwitterRelationship.last.tag_list,@rules["tags"]["tag"]           
      end
    end
    context "when saving a tweet_reaction" do
      setup do
        @tweet_reaction = {:tweet => Factory.create(:tweet),:initiator => Factory.create(:twitter_account), :responder => Factory.create(:twitter_account), :type => 'retweet'}         
      end
    
      should "allow the reaction to be tagged" do
        @saver.save(@tweet_reaction, &REACTION_SAVE)
        assert_contains TweetReaction.last.tag_list,@rules["tags"]["tag"]          
      end
    end
    
  end
  
end