Rokkincrm::App.controllers :messages do

  get :fetch do
    redirect "/" if authenticated(User).nil?
    User.dataset.each(&:fetch_messages)
    redirect "/dashboard"
  end

end
