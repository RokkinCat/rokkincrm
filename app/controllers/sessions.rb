Rokkincrm::App.controllers :sessions do

  get :index, map: "/" do
    @error = false
    render "sessions/login"
  end
  post :index, map: "/" do
    if User.authenticate(params["email"], params["password"])
      redirect "/dashboard"
    else
      @error = true
      render "sessions/login"
    end
  end

  get :register, map: "/register" do
    @user = User.new
    render "sessions/register"
  end
  post :register, map: "/register" do
    @user = User.new(params["user"])
    if @user.valid?
      @user.save
      authenticate(@user)
      redirect "/dashboard"
    else
      render "sessions/register"
    end
  end
end
