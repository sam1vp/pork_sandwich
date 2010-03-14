module Pork
  class Puller
    attr_accessor :auth_object
    
    def initialize(auth_object = nil)
      @auth_object = auth_object ? auth_object.auth : auth_object
    end
  
    def pull(user_object, &pull_type)
      @user = user_object
      begin
        pull_type.call(@user, @auth_object)
      rescue Errno::ECONNRESET   
        p "ERROR: Connection reset by peer, probably because you tried to access an unauthorized page. Moving on."  
      rescue Twitter::Unavailable
        p "ERROR: Twitter unavailable, trying in 60"
        sleep 60
        retry
      rescue Twitter::NotFound
        p "ERROR: Info target not found, trying to skip"
      # rescue Twitter::Unauthorized 
      # rescue Crack::ParseError
      #   raise Crack::ParseError
      rescue Errno::ETIMEDOUT
        p "ERROR: Puller timed out, retrying in 10"
        sleep 10
        retry
      rescue Twitter::InformTwitter
        p "ERROR: Twitter internal error, retrying in 30"
        sleep 30
        retry
      end
    end
  end
end




ACCOUNT_INFO = lambda do |user_object, auth_object|
  @pull_data = auth_object ? auth_object.user(user_object.search) : Twitter.user(user_object.search)  
  {:pull_data => @pull_data, :db_object => $SAVER.save(@pull_data, &TWITTER_ACCOUNT_SAVE)}
end

FOLLOWERS = lambda do |user, auth_object|
  user.pull_account_info
  rules = {:user_id => user.twitter_id}
  follower_relationship_db_ids = []
  # unless user.desired_follower_count
  #   $SAVER.rules[:complete_follower_set] = true
  # end
  loop do
    rules[:cursor] = -1 if !rules[:cursor]
    if auth_object
      @pull_data = auth_object.followers(rules)
    else
      @url = "http://twitter.com/statuses/followers.json?" 
      rules.each {|k,v| @url << URI.escape("#{k.to_s}=#{v.to_s}&")}
      @url.chop!
      @pull_data = Hashie::Mash.new(JSON.parse(Net::HTTP.get(URI.parse(@url))))    
    end
    @pull_data.users.each do |follower_mash|
      db_user_object = $SAVER.save(follower_mash, &TWITTER_ACCOUNT_SAVE)  
      follower_relationship_db_ids << $SAVER.save({:friend => user, :follower => Pork::TwitterUser.new(:twitter_id => follower_mash.id, :twitter_screen_name => follower_mash.screen_name, :db_object => db_user_object)}, &RELATIONSHIP_SAVE).id 
    end
    if @pull_data.next_cursor == 0
      break
    else
      rules[:cursor] = @pull_data.next_cursor
    end
  end
  {:follower_relationship_db_ids => follower_relationship_db_ids}
end

FOLLOWER_IDS = lambda do |user, auth_object|
  user.pull_account_info
  $SAVER.rules[:complete_follower_set] = true
  follower_relationship_db_ids = []
  @pull_data = auth_object ? auth_object.follower_ids({:user_id => user.twitter_id}) : Twitter.follower_ids(user.twitter_id)
  @pull_data.each do |user_id| 
    db_user_object = $SAVER.save(Pork::TwitterUser.new(:twitter_id => user_id), &TWITTER_ACCOUNT_SAVE)
    follower_relationship_db_ids << $SAVER.save({:friend => user, 
                                                 :follower => Pork::TwitterUser.new(:twitter_id => user_id, 
                                                                                    :db_object => db_user_object)},
                                                 &RELATIONSHIP_SAVE)
  end
  $SAVER.rules[:complete_follower_set] = false
  {:follower_relationship_db_ids => follower_relationship_db_ids}
end

FRIENDS = lambda do |user, auth_object|
  user.pull_account_info
  rules = {:user_id => user.twitter_id}
  friend_relationship_db_ids = []
  # unless user.desired_friend_count
  #   $SAVER.rules[:complete_friend_set] = true
  # end
  loop do
    rules[:cursor] = -1 if !rules[:cursor]
    if auth_object
      @pull_data = auth_object.friends(rules)
    else
      @url = "http://twitter.com/statuses/friends.json?" 
      rules.each {|k,v| @url << URI.escape("#{k.to_s}=#{v.to_s}&")}
      @url.chop!
      @pull_data = Hashie::Mash.new(JSON.parse(Net::HTTP.get(URI.parse(@url))))    
    end
    @pull_data.users.each do |friend_mash|
      db_user_object = $SAVER.save(friend_mash, &TWITTER_ACCOUNT_SAVE)  
      friend_relationship_db_ids << $SAVER.save({:friend => Pork::TwitterUser.new(:twitter_id => friend_mash.id, :twitter_screen_name => friend_mash.screen_name, :db_object => db_user_object), :follower => user}, &RELATIONSHIP_SAVE).id
    end
    if @pull_data.next_cursor == 0
      break
    else
      rules[:cursor] = @pull_data.next_cursor
    end
  end
  {:friend_relationship_db_ids => friend_relationship_db_ids}
end

FRIEND_IDS = lambda do |user, auth_object|
  user.pull_account_info
  $SAVER.rules[:complete_friend_set] = true
  friend_relationship_db_ids = []
  @pull_data = auth_object ? auth_object.friend_ids({:user_id => user.twitter_id}) : Twitter.friend_ids(user.twitter_id)
  @pull_data.each do |user_id| 
    db_user_object = $SAVER.save(Pork::TwitterUser.new(:twitter_id => user_id), &TWITTER_ACCOUNT_SAVE)
    friend_relationship_db_ids << $SAVER.save({:follower => user, :friend => Pork::TwitterUser.new(:twitter_id => user_id, :db_object => db_user_object)}, &RELATIONSHIP_SAVE)
  end
  $SAVER.rules[:complete_friend_set] = false
  {:friend_relationship_db_ids => friend_relationship_db_ids}
end

TWEETS = lambda do |user, auth_object|
  rules = {:count => 200}
  if user.twitter_id 
    @id = user.twitter_id
    @id_hash = {"user_id" => @id}
  else
    @id = user.screen_name
    @id_hash = {"screen_name" => @id}
  end
  @tweet_db_ids = []
  loop do 
    @pull_data = auth_object ? auth_object.user_timeline(rules.merge(@id_hash)) : Twitter.timeline(@id,rules)
    @pull_data.each do |result|
      @tweet_db_ids << $SAVER.save(result, &USER_TWEET_SAVE).id
    end
    if @pull_data.last.id == rules[:max_id]
      break
    else
      rules[:max_id] = @pull_data.last.id
    end
  end
  # rules[:reactions] ? $REACTION_PROCESSOR.process_reactions(@tweet_db_objects) : nil
  {:db_ids => @tweet_db_ids}
end

TRENDS_PULL = lambda do |rules, auth_object|
  Twitter::Trends.current().each do |trend|
    $SAVER.save({:name => trend.name, :query => trend.query}, &TREND_SAVE)
  end
end