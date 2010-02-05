# Variations within the saver class:
# - Type of object being saved (tweets, userinfo, followers, followees)
# - Which tag(s) to use 
# - Whether to save, update, or not save 
# 
# Similarities within the saver class: 
# - all recieve an object
# - all receive a rule set
module Pork
  class Saver
    attr_accessor :rules
  
    def initialize(rules = {})
      @rules = rules
    end

    def save(to_save, &save_type)
      save_type.call(to_save, rules)    
    end
  end
end
TWEET_SAVE = lambda do |tweet_to_save, rules|
  $LOG.debug "TWEET SAVE"
  tweet = Tweet.new(:text => tweet_to_save.text, 
                   :time_of_tweet => tweet_to_save.created_at,
                   :to_user_id_search => tweet_to_save.to_user_id,
                   :iso_language_code => tweet_to_save.iso_language_code,
                   :source => tweet_to_save.source,
                   :profile_image_url => tweet_to_save.profile_image_url,
                   :from_user_id_search => tweet_to_save.from_user_id,     
                   :to_user => tweet_to_save.to_user,
                   :from_user  => tweet_to_save.from_user,
                   :status_id  => tweet_to_save.status_id
                    )

  unless rules['tags'].nil?
    rules['tags'].each do |tag_name, tag_value|
      tweet.tag_list << tag_value
    end
  end

  tweet.save
  tweet
  #If not in DB
  #Active record save
  #According to rules 
  #save associations

end

USER_TWEET_SAVE = lambda do |tweet_to_save, rules|
  $LOG.debug "USER TWEET SAVE"
  tweet = Tweet.new(:text => tweet_to_save.text, 
                   :time_of_tweet => tweet_to_save.created_at,
                   :to_user_id => tweet_to_save.in_reply_to_user_id,
                   :source => tweet_to_save.source,
                   :profile_image_url => tweet_to_save.user.profile_image_url,     
                   :to_user => tweet_to_save.in_reply_to_screen_name,
                   :from_user  => tweet_to_save.user.screen_name,
                   :twitter_account_id => tweet_to_save.user.id,
                   :status_id  => tweet_to_save.id,
                   :truncated => tweet_to_save.truncated
                    )

  unless rules['tags'].nil?
    rules['tags'].each do |tag_name, tag_value|
      tweet.tag_list << tag_value
    end
  end

  tweet.save
  tweet
end
TWITTER_ACCOUNT_SAVE = lambda do |twitter_account_to_save, rules|
  $LOG.debug "TWITTER ACCOUNT SAVE"
  if twitter_account_to_save.class == Pork::TwitterUser
    twitter_account_attribute_hash = {:twitter_id => twitter_account_to_save.twitter_id,
                                      :screen_name => twitter_account_to_save.twitter_screen_name}
    twitter_account = TwitterAccount.new(twitter_account_attribute_hash)

    twitter_account_from_find = TwitterAccount.find(twitter_account.twitter_id) rescue nil
                                      
  else
    twitter_account_attribute_hash = {:twitter_id => twitter_account_to_save.id,
                        :name => twitter_account_to_save.name, 
                        :screen_name => twitter_account_to_save.screen_name, 
                        :description => twitter_account_to_save.description, 
                        :location => twitter_account_to_save.location, 
                        :profile_image_url => twitter_account_to_save.profile_image_url, 
                        :url => twitter_account_to_save.url, 
                        :protected => twitter_account_to_save.protected, 
                        :followers_count => twitter_account_to_save.followers_count, 
                        :statuses_count => twitter_account_to_save.statuses_count, 
                        :friends_count => twitter_account_to_save.friends_count, 
                        :profile_background_image_url => twitter_account_to_save.profile_background_image_url, 
                        :profile_background_tile => twitter_account_to_save.profile_background_tile,
                        :favourites_count => twitter_account_to_save.favourites_count, 
                        :time_zone => twitter_account_to_save.time_zone, 
                        :utc_offset => twitter_account_to_save.utc_offset,
                        :time_of_user_creation => twitter_account_to_save.created_at,
                        :profile_background_color => twitter_account_to_save.profile_background_color,
                        :profile_text_color => twitter_account_to_save.profile_text_color,
                        :profile_link_color => twitter_account_to_save.profile_link_color,
                        :profile_sidebar_fill_color => twitter_account_to_save.profile_sidebar_fill_color,
                        :profile_sidebar_border_color => twitter_account_to_save.profile_sidebar_border_color,
                        :notifications => twitter_account_to_save.notifications,
                        :verified => twitter_account_to_save.verified,
                        :twitter_id_for_search => twitter_account_to_save.twitter_id_for_search}    
    twitter_account = TwitterAccount.new(twitter_account_attribute_hash)

    twitter_account_from_find = TwitterAccount.find_by_screen_name(twitter_account.screen_name)

  end


  if twitter_account_from_find

    twitter_account = twitter_account_from_find
    unless rules['tags'].nil?
      rules['tags'].each do |tag_name, tag_value|
        twitter_account.tag_list << tag_value
      end
    end
    twitter_account.update_attributes(twitter_account_attribute_hash)  
  else
    unless rules['tags'].nil?
      rules['tags'].each do |tag_name, tag_value|
        twitter_account.tag_list << tag_value
      end
    end
     twitter_account.save
  end                    
  
  twitter_account

end
CALL_SAVE = lambda do |call_to_save, rules|
  $LOG.debug "CALL SAVE"
  call = Call.new(:query => call_to_save.query,
                  :completed_in =>  call_to_save.completed_in,
                  :since_id => call_to_save.since_id,
                  :max_id => call_to_save.max_id,
                  :refresh_url => call_to_save.refresh_url,
                  :results_per_page => call_to_save.results_per_page,
                  :next_page => call_to_save.next_page,
                  :page => call_to_save.page,
                  :api => call_to_save.api_id)
  unless rules['tags'].nil?
    rules['tags'].each do |tag_name, tag_value|
      call.tag_list << tag_value
    end
  end
  call.save
  call
end

RELATIONSHIP_SAVE = lambda do |users_to_save, rules|
    $LOG.debug "RELATIONSHIP SAVE"
  follower = users_to_save[:follower]
  friend = users_to_save[:friend]      

  twitter_relationship = TwitterRelationship.new(:follower_id => follower.db_object.id, :friend_id => friend.db_object.id, :current => true)
  if rules[:complete_friend_set]
    twitter_relationship[:complete_friend_set] = rules[:complete_friend_set]
  end
  if rules[:complete_follower_set]
     twitter_relationship[:complete_follower_set] = rules[:complete_follower_set]
  end

  unless rules['tags'].nil?
    rules['tags'].each do |tag_name, tag_value|
      twitter_relationship.tag_list << tag_value
    end
  end
  twitter_relationship.save
  twitter_relationship
end



REACTION_SAVE = lambda do |reaction_to_save, rules|
  $LOG.debug "REACTION SAVE"
  
  
  initiator = reaction_to_save[:initiator]
  responder = reaction_to_save[:responder]
  tweet = reaction_to_save[:tweet]
  reaction_type = reaction_to_save[:type]

  tweet_reaction = TweetReaction.new(:tweet_id => tweet.id, 
                                     :reaction_id => Reaction.find_by_reaction_type(reaction_type).id, 
                                     :initiator_id => initiator.id, 
                                     :responder_id => responder.id)

  
  
  unless rules['tags'].nil?
    rules['tags'].each do |tag_name, tag_value|
      tweet_reaction.tag_list << tag_value
    end
  end

  tweet_reaction.save
  tweet_reaction
end

TREND_SAVE = lambda do |trend_to_save, rules|
  trend = Trend.new(:name => trend_to_save[:name], :query => trend_to_save[:query])
  trend.save
  trend
end
