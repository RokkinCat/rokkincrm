class User < Sequel::Model
  include Shield::Model
  def fetch(email)
    return first(email: email)
  end
end
