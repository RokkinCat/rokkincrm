module Rokkincrm
  class App < Padrino::Application
    register SassInitializer
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get "/dashboard" do
      @messages = Message.dataset
      render "dashboard"
    end

  end
end
