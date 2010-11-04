namespace :mstp do 
  task :check_twitter => :environment do
    search = ENV['search'] || '#mcdmresearch'
    Tweet.ingest_by_search(search)  
  end

  task :follow_term => :environment do
    Delayed::Job.enqueue TwitterGetter.new(ENV['search'])
  end

  task :clear_term => :environment do
    jobs = Delayed::Job.find_all_by_handler(TwitterGetter.new(ENV['search']).to_yaml)
    jobs.each {|job| job.destroy}
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
