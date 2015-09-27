desc "This task is called by the Heroku scheduler add-on"
task :hoge => :environment do
  puts "hoge"
end
