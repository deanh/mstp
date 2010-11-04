class Tweet
  CONSUMER_KEY    = "dixiSQB4OQXcDjqsmaDkWQ"
  CONSUMER_SECRET = "ctWIjMQkIBn3mCCGNeoXWZcW02b8wTTLPjb7drZbU0"
  ACCESS_TOKEN    = "211786238-e8LMISiQlxmi7UxiFeUx10FT2A9od86PAKJHEhD8"
  ACCESS_SECRET   = "WKSWdyRu8o6JX7TBnQwRSq9gRuqL4Va6LR27Rj5I"

  def post(tweet)
    oauth = Twitter::OAuth.new(CONSUMER_KEY, CONSUMER_SECRET)
    oauth.authorize_from_access(ACCESS_TOKEN, ACCESS_SECRET)

    client = Twitter::Base.new(oauth)
    client.update(tweet)
  end

  def self.ingest_by_search(search_term)
    Twitter::Search.new(search_term).each do |tweet|
      next if Comment.find_by_uid("#{tweet.id}")
      c = create_comment(tweet, search_term)
      if defined? c.twitter_handle
        puts "@#{c.twitter_handle} - MSTP comment thread here: http://localhost:3000/comment/#{c.id}"      
        post "@#{c.twitter_handle} - MSTP comment thread here: http://localhost:3000/comment/#{c.id}"
      end
      c
    end
  end

  def self.create_comment(tweet, search_term = nil)
    c = Comment.new
    c.content             = tweet.text
    c.title               = "At #{tweet.created_at} via Twitter"
    c.source              = "twitter"
    c.twitter_handle      = tweet.from_user
    c.twitter_response_to = tweet.to_user
    c.search_term         = search_term
    c.uid                 = "#{tweet.id}"
    if u = User.find_by_twitter_handle(c.twitter_handle)
      c.user = u
    end

    # a kind of lame attempt to thread
    if c.twitter_response_to
        parent = Comment.find(:all, :conditions => "twitter_handle = '#{c.twitter_response_to}' and parent_id is NULL",
                              :order => "created_at DESC",
                              :limit => 1)
      c.parent = parent.first if parent.first
    end
    puts c.content
    c.save
    return c
  end

end
