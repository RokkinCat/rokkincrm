class User < Sequel::Model
  include Shield::Model
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
end
