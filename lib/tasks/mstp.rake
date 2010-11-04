namespace :mstp do 
  task :check_twitter => :environment do
    search = ENV['search'] || '#mcdmresearch'
    Tweet.ingest_by_search(search)  
  end

  task :follow_term => :environment do
    debugger
    Delayed::Job.enqueue TwitterGetter.new(ENV['search'])
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
