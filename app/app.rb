module Rokkincrm
  class App < Padrino::Application
    register SassInitializer
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get "/dashboard" do
      current_user.fetch_messages
      @messages = Message.dataset.where(user_id: current_user.id)
      render "dashboard"
    end

  end
end
