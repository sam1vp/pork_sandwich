class PorkSandwichModelsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "models/reaction.rb", "app/models/reaction.rb"
      m.file "models/trend.rb", "app/models/trend.rb"
      m.file "models/tweet.rb", "app/models/tweet.rb"
      m.file "models/tweet_reaction.rb", "app/models/tweet_reaction.rb"
      m.file "models/twitter_account.rb", "app/models/twitter_account.rb"
      m.file "models/twitter_relationship.rb", "app/models/twitter_relationship.rb"
    end
  end
end