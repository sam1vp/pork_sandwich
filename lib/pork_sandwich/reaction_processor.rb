module Pork
  class ReactionProcessor 
  attr_accessor :rules, :user
    def initialize(user, rules = {:pull_secondary_influence_user_info => false})
      @rules = rules
      @user = user
      fill_in_user_info
    end

    def process_reactions()  
      if rules[:mention_from] or rules[:reply_from] or rules[:rt_from]
        if user.twitter_id
          tweet_ids = $TWITERATOR.twiterate({}, {:user_id => user.twitter_id}, &USER_TWEETS_ITER)[:tweets]
        else
          tweet_ids = $TWITERATOR.twiterate({}, {:screen_name => user.twitter_screen_name}, &USER_TWEETS_ITER)[:tweets]        
        end 
        if rules[:rt_from]
          $TWITERATOR.twiterate({}, {:from => user.twitter_screen_name, :search_query => "RT"}, &SEARCH_ITER)[:tweets].each do |tweet_id|
            tweet_ids << tweet_id
          end
        end
        tweets_from_tweet_ids(tweet_ids).each do |tweet|
          influentials = parse_tweet_for_influentials(tweet)
          if rules[:mention_from] 
            influentials[:mention_screen_names].each do |screen_name|
              save_from(screen_name, tweet, 'mention')
            end
          end
          if rules[:reply_from] 
            save_from(influentials[:reply_screen_name], tweet, 'reply')
          end
          if rules[:rt_from]
            influentials[:rt_screen_names].each do |screen_name|
              save_from(screen_name, tweet, 'retweet')
            end
            pull_and_save_rts_from
          end
        end
      end
      if rules[:mention_to] or rules[:reply_to] or rules[:rt_to]
        tweet_ids = []
        $TWITERATOR.twiterate({}, {:search_query => "#{user.twitter_screen_name}"}, &SEARCH_ITER)[:tweets].each do |tweet_id|
          tweet_ids << tweet_id
        end
        tweets_from_tweet_ids(tweet_ids).each do |tweet|
          source_user_screen_name = tweet.from_user
          influentials = parse_tweet_for_influentials(tweet)
          if rules[:mention_to]
            influentials[:mention_screen_names].each do |screen_name|
              if screen_name == user.twitter_screen_name
                save_to(source_user_screen_name, tweet, 'mention')
              end
            end
          end
          if rules[:reply_to]
            if influentials[:reply_screen_name] == user.twitter_screen_name
              save_to(source_user_screen_name, tweet, 'reply')
            end
          end
          if rules[:rt_to]
            influentials[:rt_screen_names].each do |screen_name|
              if screen_name == user.twitter_screen_name
                save_to(source_user_screen_name, tweet, 'retweet')
              end
            end
          end
        end
      end
    end  


    def save_from(secondary_screen_name, tweet, type)
      $SAVER.save({:initiator => user.db_object, :responder => find_or_create_secondary_account(secondary_screen_name), :tweet => tweet, :type => type}, &REACTION_SAVE)
    end

    def save_to(secondary_screen_name, tweet, type)
       $SAVER.save({:initiator => find_or_create_secondary_account(secondary_screen_name), :responder => user.db_object, :tweet => tweet, :type => type}, &REACTION_SAVE)
    end

    def tweets_from_tweet_ids(tweet_ids)
      tweets = tweet_ids.map do |tweet_id| Tweet.find(tweet_id) end
    end

 

    def parse_tweet_for_influentials(tweet) 
      mention_regex = /[@]\w+/
      reply_regex = /^[@]\w+/
      rt_regex = /(^[Rr][Tt] ?[@]\w+(:?)| [Rr][Tt] ?[@]\w+(:?))/  
      t_copy = tweet.text.dup
      reply_screen_name = t_copy.scan(reply_regex)
      reply_screen_name.each do |ru|
        t_copy.slice!(/^#{ru}/)
      end
      rt_screen_names = t_copy.scan(rt_regex)
      unless rt_screen_names.empty?
        rt_screen_names.map! do |rt| rt.first end
      end
      rt_screen_names.each do |rtu|
        t_copy.slice!(/^#{rtu}| #{rtu}/)
      end
      mention_screen_names = t_copy.scan(mention_regex)
      sanitize_screen_names(reply_screen_name.first, rt_screen_names, mention_screen_names)
    end 

    def sanitize_screen_names(reply_screen_name, rt_screen_names, mention_screen_names)
        sanitizing_regex = / ?([rR][tT])? ?@/
        reply_screen_name ? reply_screen_name.slice!(sanitizing_regex) : nil
        rt_screen_names.each do |rtu| 
          rtu.slice!(sanitizing_regex) 
        end
        mention_screen_names.each do |mu| 
          mu.slice!(sanitizing_regex) 
        end
        {:reply_screen_name => reply_screen_name, :rt_screen_names => rt_screen_names, :mention_screen_names => mention_screen_names}
    end
  
    def fill_in_user_info
      if not user.db_object
        user.db_object = $PULLER.pull({:user=>user}, &USER_PULL)[:db_object]
      end
    end
  
    def find_or_create_secondary_account(screen_name)
      account = TwitterAccount.find_by_screen_name(screen_name)
      unless account  
        if rules[:pull_secondary_influence_user_info]
          account = $PULLER.pull({:user => Pork::TwitterUser.new(:twitter_screen_name => screen_name)})[:db_object]
        else
          account = TwitterAccount.create(:screen_name => screen_name)
        end
      end
      account
    end
  
    def pull_and_save_rts_from
    
    end
  end
end
