# require "#{File.dirname(__FILE__)}/test_helper"
# 
# 
# class CrawlerTest < Test::Unit::TestCase
#   context "A crawler initialized with a user array" do
#     setup do
#       $CRAWLER = Pork::Crawler.new([Pork::TwitterUser.new(:twitter_id => 15019521, :crawled => false)], 2, &FOLLOWERS_CRAWL)
#       $PULLER = Pork::Puller.new($AUTH)
#       $TWITERATOR = Pork::Twiterator.new()
#       $SAVER = Pork::Saver.new
#       $LOG = Logger.new(STDOUT)
#       $LOG.level = Logger::INFO
#     end
#     # should "convert the array into a hash" do
#     #   assert_same_elements $CRAWLER.users, {15019521 => 'uncrawled'} 
#     # end    
#     # should "be able to append new and not new users" do
#     #   $CRAWLER.append('user3')
#     #   $CRAWLER.append(15019521)
#     #   assert_same_elements $CRAWLER.users , {15019521 => 'uncrawled','user3' => 'uncrawled'}
#     # end
#     # should "return the initial users when called to a depth of 0" do
#     #   $CRAWLER.depth = 0
#     #   assert_same_elements [15019521], $CRAWLER.crawl()
#     # end
#     # should "be able to crawl 2 depths of follower ids" do
#     #   $CRAWLER.crawl_type = FOLLOWER_IDS_CRAWL
#     #   assert_same_elements [15019521, 55555, 4444, 333, 22, 1], $CRAWLER.crawl()
#     # end
#     # should "be able to crawl 2 depths of friend ids" do
#     #   $CRAWLER.crawl_type = FRIEND_IDS_CRAWL
#     #   assert_same_elements  [15019521, 55555, 4444, 333, 22, 1], $CRAWLER.crawl()
#     # end
#     should "be able to gather users from a twitter search" do
#       $CRAWLER.users = []
#       $CRAWLER.depth = 0
#       $CRAWLER.crawl_type = SEARCH_CRAWL 
#       @test_result = $CRAWLER.crawl('test').map do |u| u.twitter_screen_name end 
#       assert_same_elements ["SamIsMarth", "MarthIsGreat", "EvanIsLucas", "LucasIsCheap"], @test_result
#     end
#     # should "be able to crawl 2 depths of followers" do 
#     #      $CRAWLER.crawl_type = FOLLOWERS_CRAWL 
#     #      assert_same_elements [55555,4444,333,22,1,15019521], $CRAWLER.crawl()
#     #    end
#     #    should "be able to crawl 2 depths of friends" do 
#     #      $CRAWLER.crawl_type = FRIENDS_CRAWL 
#     #       assert_same_elements [55555,4444,333,22,1,15019521], $CRAWLER.crawl()
#     #    end
#   end
#   
#   
# end
