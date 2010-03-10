module Pork
  class Search
    attr_reader :query, :db_ids_created, :desired_count, :from_user, :current_count
  
    def initialize(query, options = {})
      @query = query
      @desired_count = options[:desired_count] #if nil, will pull as far back as the Search API allows
      @current_count = 0
      @since_id = options[:since_id]
      @from_user = options[:from_user] 
      @db_ids_created = []
      @collect_users = options[:collect_users]
      @pulls_per_hour = options[:pulls_per_hour]? options[:pulls_per_hour] : 2000
    end
    
    def historical_pull
      @search_params = Twitter::Search.new(@query).per_page(100)
      @search_params.from(@from_user) if @from_user
      begin
        loop do
          time_at_start = Time.now
          if $PORK_LOG 
            $PORK_LOG.write("historical pull, query = #{@query}, max_id = #{@search_params.query[:max_id].to_s}")
          end
          @return_data = @search_params.dup.fetch
          if @return_data.error == "You have been rate limited. Enhance your calm."
            raise Pork::RateLimitExceeded
          end
          @tweets_pulled = @return_data.results
          @tweets_pulled.each do |tweet|
            tweet.status_id = tweet.id   
            if reached_desired_count? or reached_since_id?(tweet.status_id)
              break
            end
            @db_ids_created << $SAVER.save(tweet, &TWEET_SAVE).id
            # $CRAWLER.append(tweet.from_user) if @collect_users
            @current_count += 1
          end
          if reached_desired_count? or @search_params.query[:max_id] == @tweets_pulled.last.id or reached_since_id?(@tweets_pulled.last.id)
            break
          else
            @search_params.query[:max_id] = @tweets_pulled.last.id
          end
          manage_pull_rate(time_at_start)
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
        @search_params.query[:max_id] -= 1000 if @search_params.query[:max_id]
        manage_pull_rate
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
      rescue Pork::RateLimitExceeded
       if $PORK_LOG
           $PORK_LOG.write("ERROR: Rate limit exceeded; holding off for a bit then trying again")
        end
        sleep 300
        reduce_pull_rate
        retry
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
    
    def manage_pull_rate(time_at_start)
      desired_pause = 1.0 / (@pulls_per_hour / 60.0 / 60.0)
      pull_duration = Time.now - time_at_start
      if desired_pause - pull_duration > 0 
        actual_pause = desired_pause - pull_duration
      else
        actual_pause = 0
      end
      sleep actual_pause
    end
    
    def reduce_pull_rate
      if @pulls_per_hour > 100
        @pulls_per_hour -= 100
      end
    end
    
    def reached_since_id?(id)
      if @since_id
        return id <= @since_id
      else
        return false
      end
    end
    
  end
end