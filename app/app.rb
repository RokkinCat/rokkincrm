module Rokkincrm
  class App < Padrino::Application
    register SassInitializer
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get "/dashboard" do
      authenticated(User).fetch_messages
      @messages = Message.dataset.where(user_id: authenticated(User).id)
      render "dashboard"
    end

  end
end
