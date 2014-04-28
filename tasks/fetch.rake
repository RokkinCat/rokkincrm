task :fetch => :environment do
  User.each do |user|
    fetcher = IMAPFetcher.new(user)
    messages = fetcher.fetch_recent(user.last_fetch)

    messages.each do |message|

    end

    user.update(last_fetch: Time.now)
  end
end
