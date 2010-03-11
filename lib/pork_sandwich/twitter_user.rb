module Pork
  class TwitterUser
    attr_accessor :twitter_id, :twitter_screen_name, :crawled, :user_info, :db_object, :puller, :desired_follower_count, :desired_friend_count
    attr_reader :tweet_db_ids, :follower_relationship_db_ids, :friend_relationship_db_ids
  
  
    def initialize(opts)
      @twitter_id = sanitize_id(opts[:twitter_id])
      @twitter_screen_name = opts[:twitter_screen_name]
      @crawled = opts[:crawled]
      @user_info = opts[:user_info]
      @db_object = opts[:db_object]
      @puller = opts[:puller]
      @tweet_db_ids = nil
      @follower_relationship_db_ids = nil
      @friend_relationship_db_ids = nil
      @desired_follower_count = opts[:desired_follower_count]
      @desired_friend_count = opts[:desired_friend_count]
    end

    def crawled?
      @crawled
    end
    
    def search
      twitter_id ? twitter_id : twitter_screen_name    
    end

    def sanitize_id(id)
      id.nil? ? nil : id.to_i 
    end
    
    def pull_tweets
      pull_result = self.puller.pull(self, &TWEETS)
      @tweet_db_ids = pull_result[:db_ids]
      return true
    end
    
    def pull_account_info
      unless @user_info && @db_object
        self.update_account_info
      end
    end
    
    def update_account_info
      pull_result = self.puller.pull(self, &ACCOUNT_INFO)
      @user_info, @db_object, @twitter_id, @twitter_screen_name = pull_result[:pull_data], pull_result[:db_object], pull_result[:db_object].twitter_id, pull_result[:db_object].screen_name 
      return true
    end
    
    def pull_followers
      pull_result = self.puller.pull(self, &FOLLOWERS)
      @follower_relationship_db_ids = pull_result[:follower_relationship_db_ids]
    end
    
    def pull_friends
      pull_result = self.puller.pull(self, &FRIENDS)
      @friend_relationship_db_ids = pull_result[:friend_relationship_db_ids]
    end
    
    def pull_follower_ids
      pull_result = self.puller.pull(self, &FOLLOWER_IDS)
      @follower_relationship_db_ids = pull_result[:follower_relationship_db_ids]
    end
    
    def pull_friend_ids
      pull_result = self.puller.pull(self, &FRIEND_IDS)
      @friend_relationship_db_ids = pull_result[:friend_relationship_db_ids]
    end
    
    def puller
      unless @puller
        @puller = Pork::Puller.new($AUTH)
      end
      @puller
    end
    
    
    
    
  
  end
end