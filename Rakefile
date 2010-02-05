require 'rake/testtask'
require 'active_record'
require 'rcov'
require 'metric_fu'
require 'acts-as-taggable-on'
require 'twitter'

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :connect do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end


desc "Loads the database environment"
task :environment => :connect do 
  ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
  ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger
  
  require 'lib/pork'
end

task :connect do
  ActiveRecord::Base.establish_connection(YAML::load(File.open("config/database.yml"))['production'])
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  
end

MetricFu::Configuration.run do |config|
  #define which metrics you want to use
  #eliminated "stats" because it's specific to rails
  config.metrics  = [:churn, :saikuro, :flog, :flay, :reek, :roodi, :rcov]
  config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
  config.flay     = { :dirs_to_flay => ['lib']  } 
  config.flog     = { :dirs_to_flog => ['lib']  }
  config.reek     = { :dirs_to_reek => ['lib']  }
  config.roodi    = { :dirs_to_roodi => ['lib'] }
  config.saikuro  = { :output_directory => 'scratch_directory/saikuro', 
                      :input_directory => ['lib'],
                      :cyclo => "",
                      :filter_cyclo => "0",
                      :warn_cyclo => "5",
                      :error_cyclo => "7",
                      :formater => "text"} 
  config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
  config.rcov     = { :test_files => ['test/*_test.rb'],
                      :rcov_opts => ["--sort coverage", 
                                     "--no-html", 
                                     "--text-coverage",
                                     "--no-color",
                                     "--profile"]}
end

