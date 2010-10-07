require 'twitter'

namespace :mstp do 
  task :check_twitter => :environment do
    Twitter::Search.new('#mcdmresearch').each do |tweet|
      next if Comment.find_by_uid(tweet.id)
      c = Comment.new
      c.content = tweet.text
      c.title   = "At #{tweet.created_at} from @#{tweet.from_user}"
      c.source  = "twitter"
      c.uid     = tweet.id
      #puts c.title
      puts c.content
      c.save
    end
  end
end
