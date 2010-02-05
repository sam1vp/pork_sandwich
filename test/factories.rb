Factory.sequence :status_id do |n|
  "1432#{n}".to_i
end

Factory.define :tweet do |t|
    t.text "Someting to tweet about"
    t.from_user "aplusk"
    t.status_id {Factory.next(:status_id)}       
end

Factory.define :retweet1_tweet, :parent => :tweet do |t|
    t.text "RT @username blah blah blah"
end

Factory.define :retweet2_tweet, :parent => :tweet do |t|
    t.text "Someting to tweet about RT @username blah blah blah"
end

Factory.define :mention_tweet, :parent => :tweet do |t|
    t.text "Someting to @username tweet about"  
end

Factory.define :reply_tweet, :parent => :tweet do |t|
    t.text "@username Someting to tweet about"    
end

Factory.define :double_mention_tweet, :parent => :tweet do |t|
    t.text "Someting @username1 to @username2 tweet about" 
end

Factory.sequence :screen_name do |n|
  "User#{n}"
end

Factory.sequence :twitter_id do |n|
  "11#{n}".to_i
end

Factory.define :twitter_account do |tw|
    tw.screen_name {Factory.next(:screen_name)}
    tw.twitter_id {Factory.next(:twitter_id)}
end


Factory.define :tweet_reaction do |tr|
   tr.reaction {Factory.create(:reaction)}
   tr.tweet {Factory.create(:tweet)}
   tr.responder {Factory.create(:twitter_account)}
   tr.initiator {Factory.create(:twitter_account)}
end

Factory.define :reaction do |r|
   r.reaction_type "at mention"
   r.value 0.6
end

