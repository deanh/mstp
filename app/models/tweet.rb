require 'twitter'

class Tweet
  def self.ingest_by_search(search_term)
    Twitter::Search.new(search_term).each do |tweet|
      next if Comment.find_by_uid(tweet.id)
      #next if tweet.text.match(/^@/)
      create_comment(tweet)
    end
  end

  def self.create_comment(tweet)
    c = Comment.new
    c.content             = tweet.text
    c.title               = "At #{tweet.created_at} via Twitter"
    c.source              = "twitter"
    c.twitter_handle      = tweet.from_user
    c.twitter_response_to = tweet.to_user
    c.uid                 = "#{tweet.id}"
    if u = User.find_by_twitter_handle(c.twitter_handle)
      c.user = u
    end

    # a kind of lame attempt to thread
    if c.twitter_response_to
        parent = Comment.find(:conditions => "twitter_handle = '#{c.twitter_response_to}' and parent_id is NULL",
                              :order => "created_at DESC",
                              :limit => 1)
      c.parent = parent if parent
    end
    puts c.content
    c.save
  end
end
