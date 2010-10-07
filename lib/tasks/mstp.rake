require 'twitter'

namespace :mstp do 
  task :check_twitter => :environment do
    Twitter::Search.new('#mcdmresearch').each do |tweet|
      next if Comment.find_by_uid(tweet.id)
      next if tweet.text.match(/^@/)
      c = Comment.new
      c.content = tweet.text
      c.title   = "At #{tweet.created_at} from @#{tweet.from_user}"
      c.source  = "twitter"
      c.uid     = tweet.id
      puts c.content
      c.save
    end
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
