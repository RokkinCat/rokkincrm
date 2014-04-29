require 'nkf'

task :fetch => :environment do
  User.each do |user|
    fetcher = IMAPFetcher.new(user)
    messages = fetcher.fetch_recent(user.last_fetch || Date.today)

    messages.each do |message|
      next unless Message.first(message_id: NKF.nkf("-mw", message.message_id.to_s)).nil?

      message_model = Message.new

      message_model.subject = NKF.nkf("-mw", message.subject.to_s)
      message_model.message_id = NKF.nkf("-mw",message.message_id.to_s)
      message_model.from = NKF.nkf("-mw",message.from.to_s)
      message_model.to = message.to.map(&:to_s).map{|m| NKF.nkf("-mw", m) }
      message_model.cc = (message.cc || []).map(&:to_s).map{|m| NKF.nkf("-mw", m) }
      message_model.bcc = (message.bcc || []).map(&:to_s).map{|m| NKF.nkf("-mw", m)}
      message_model.references = ([message.references].flatten).map(&:to_s).map{|m| NKF.nkf("-mw", m) }

      if message.body.multipart?
        message_model.body = NKF.nkf("-mw",message.body.parts.map(&:body).join(" "))
      else
        message_model.body = NKF.nkf("-mw",message.body)
      end

      message_model.rfc822 = NKF.nkf("-mw",message.raw_source)
      message_model.sent_at = message.date
      message_model.created_at = Time.now
      message_model.save if message_model.valid?
    end

    user.update(last_fetch: Time.now)
  end
end
