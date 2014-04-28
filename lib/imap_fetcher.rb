require 'net/imap'

class IMAPFetcher
  def initialize(user)
    @user = user
    @imap = Net::IMAP.new(user.server, port: 993, ssl: true)
    @imap.login(@user.imap_username, @user.imap_password)
  end

  def fetch_recent(count=5)
    @imap.examine('INBOX')

    # Split off into a thread for
    # each fetched message and grab
    # their data
    threads = []
    msgs = []
    @imap.search(['UNSEEN'])[0..count].map do |mid|
      threads << Thread.new do
        msgs << Mail.new(@imap.fetch(mid, "RFC822")[0].attr["RFC822"])
      end
    end
    threads.each(&:join)

    return msgs
  end

  def logout
    @imap.logout
    @imap.disconnect
  end
end
