# Helper methods defined here can be accessed in any controller or view in the application

Rokkincrm::App.helpers do
  include Shield::Helpers

  def current_user
    authenticated(User)
  end
end
