require 'twitter'

namespace :mstp do 
  task :check_twitter => :environment do
    search = ENV['search'] || '#mcdmresearch'
    #Twitter::Search.new(search).each do |tweet|
    #  next if Comment.find_by_uid(tweet.id)
    #  next if tweet.text.match(/^@/)
    #  c = Comment.new
    #  c.content             = tweet.text
    #  c.title               = "At #{tweet.created_at} via Twitter"
    #  c.source              = "twitter"
    #  c.twitter_handle      = tweet.from_user
    #  c.twitter_response_to = tweet.to_user
    #  c.uid                 = tweet.id
    #  puts c.content
    #  c.save
    Tweet.ingest_by_search(search)  
  end

  #remove twitter @-replies from the comment root 
  task :remove_at_replies => :environment do
    Comment.find(:all, :conditions => "parent_id is NULL") do |c|
      if c.content.match(/^@/)
        puts c.content
        c.destroy
      end
    end
  end
end
