class TwitterGetter
  attr_accessor :term
  
  def initialize(search_term)
    @term = search_term
  end
  
  def perform
    Tweet.ingest_by_search(@term)
    Delayed::Job.enqueue TwitterGetter.new(@term)
  end    
end

