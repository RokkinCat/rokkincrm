require 'nkf'

task :fetch => :environment do
  User.each(&:fetch_messages)
end
