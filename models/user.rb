require 'nkf'

class User < Sequel::Model
  include Shield::Model

  one_to_many :messages

  def self.fetch(email)
    return first(email: email)
  end

  plugin :validation_helpers
  def validate
    super
    validates_unique :email
    validates_unique :imap_username
    validates_presence [:email, :server, :imap_username, :imap_password]
  end

  def fetch_messages
    fetcher = IMAPFetcher.new(self)
    messages = fetcher.fetch_recent(self.last_fetch || Date.today)

    messages.each do |message|
      next unless Message.first(message_id: NKF.nkf("-mw", message.message_id.to_s)).nil?

      message_model = Message.new

      message_model.subject = NKF.nkf("-mw", message.subject.to_s)
      message_model.message_id = NKF.nkf("-mw",message.message_id.to_s)
      message_model.from = NKF.nkf("-mw",message.from[0].to_s)
      message_model.to = [message.to].flatten.map(&:to_s).map{|m| NKF.nkf("-mw", m) }
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

      self.add_message(message_model)
    end
    self.update(last_fetch: Time.now)
  end
end
