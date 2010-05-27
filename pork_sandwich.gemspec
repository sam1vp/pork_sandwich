# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pork_sandwich}
  s.version = "0.4.21"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Gilbert", "Evan Burchard"]
  s.date = %q{2010-05-26}
  s.description = %q{Ideal for pulling Twitter search tweets, tweets from a twitter account, twitter account info, twitter relationship data, and trends. All data is stored in a handy schema for easy access.}
  s.email = %q{sam.o.gilbert@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "README",
     "Rakefile",
     "VERSION",
     "generators/pork_sandwich_migration/pork_sandwich_migration_generator.rb",
     "generators/pork_sandwich_migration/templates/migration.rb",
     "generators/pork_sandwich_models/pork_sandwich_models_generator.rb",
     "generators/pork_sandwich_models/templates/models/reaction.rb",
     "generators/pork_sandwich_models/templates/models/trend.rb",
     "generators/pork_sandwich_models/templates/models/tweet.rb",
     "generators/pork_sandwich_models/templates/models/tweet_reaction.rb",
     "generators/pork_sandwich_models/templates/models/twitter_account.rb",
     "generators/pork_sandwich_models/templates/models/twitter_relationship.rb",
     "lib/pork_sandwich.rb",
     "lib/pork_sandwich/auth.rb",
     "lib/pork_sandwich/crawler.rb",
     "lib/pork_sandwich/log.rb",
     "lib/pork_sandwich/puller.rb",
     "lib/pork_sandwich/reaction_processor.rb",
     "lib/pork_sandwich/saver.rb",
     "lib/pork_sandwich/search.rb",
     "lib/pork_sandwich/twitter_user.rb"
  ]
  s.homepage = %q{http://github.com/sam1vp/pork_sandwich}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A tool for pulling and storing delicious, delicious Twitter data}
  s.test_files = [
    "test/auth_test.rb",
     "test/crawler_test.rb",
     "test/factories.rb",
     "test/fakewebs.rb",
     "test/log_test.rb",
     "test/puller_test.rb",
     "test/reaction_processor_test.rb",
     "test/saver_test.rb",
     "test/schema.rb",
     "test/search_test.rb",
     "test/test_helper.rb",
     "test/twitter_user_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<acts-as-taggable-on>, [">= 1.0.12"])
      s.add_runtime_dependency(%q<twitter>, [">= 0.7.9"])
    else
      s.add_dependency(%q<acts-as-taggable-on>, [">= 1.0.12"])
      s.add_dependency(%q<twitter>, [">= 0.7.9"])
    end
  else
    s.add_dependency(%q<acts-as-taggable-on>, [">= 1.0.12"])
    s.add_dependency(%q<twitter>, [">= 0.7.9"])
  end
end

