desc "This task is called by the Heroku scheduler add-on"
task :send_posts => :environment do
  puts "Sending posts..."
  SendPostsJob.new.perform
  puts "done."
end
