module Pork
  class Search
    attr_reader :query, :db_ids_created, :desired_count, :from_user, :current_count
  
    def initialize(query, options = {})
      @query = query
      @desired_count = options[:desired_count] #if nil, will pull as far back as the Search API allows
      @current_count = 0
      @from_user = options[:from_user] 
      @db_ids_created = []
      @collect_users = options[:collect_users]
    end
    
    def historical_pull
      @search_params = Twitter::Search.new(@query).per_page(100)
      @search_params.from(@from_user) if @from_user
      begin
        loop do
          if $PORK_LOG 
            $PORK_LOG.write("historical pull, query = #{@query}, max_id = #{@search_params.query[:max_id].to_s}")
          end
          @tweets_pulled = @search_params.dup.fetch.results
          @tweets_pulled.each do |tweet|
            tweet.status_id = tweet.id   
            @db_ids_created << $SAVER.save(tweet, &TWEET_SAVE).id
            # $CRAWLER.append(tweet.from_user) if @collect_users
            @current_count += 1
            if reached_desired_count? 
              break
            end
          end
          if reached_desired_count? or @search_params.query[:max_id] == @tweets_pulled.last.id
            break
          else
            @search_params.query[:max_id] = @tweets_pulled.last.id
          end
        end
      rescue Twitter::Unavailable
        if $PORK_LOG
           $PORK_LOG.write("ERROR: Twitter unavailable, trying in 60")
        end
        sleep 60
        retry
      rescue Twitter::NotFound
        if $PORK_LOG
           $PORK_LOG.write("ERROR: Info target not found, trying to skip")
        end
        retry
      rescue Crack::ParseError
        if $PORK_LOG
           $PORK_LOG.write("Error: JSON Parsing error, trying to skip past problem tweet")
        end
        @search_params.query[:max_id] -= 1000
        retry
      rescue Errno::ETIMEDOUT
        if $PORK_LOG
           $PORK_LOG.write("ERROR: Puller timed out, retrying in 10")
        end
        sleep 10
        retry
      rescue Twitter::InformTwitter
        if $PORK_LOG
           $PORK_LOG.write("ERROR: Twitter internal error, retrying in 30")
        end
        sleep 30
        retry
#      rescue NoMethodError
#        p "Rate limited; holding off for a bit then trying again"
#        sleep 600
#        retry
      end
      return true
    end
    
    def reached_desired_count?
      if @desired_count
        return @current_count >= @desired_count
      else
        return false
      end
    end
    
  end
end