class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect '/reports'
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    if User.find_by(username: params[:username])
      flash[:failure] = "Username is Taken"
      redirect '/signup'
    elsif params[:username] == "signup" || params[:username] == "login"
      flash[:failure] = "Please Choose a Different Username"
      redirect '/signup'
    elsif params[:username].length < 6
      flash[:failure] = "Username Must be Six or More Characters"
      redirect '/signup'
    elsif params[:password].length < 6
      flash[:failure] = "Password Must be Six or More Characters"
      redirect '/signup'
    elsif (/[^\w]{1}/ =~ params[:password]).nil? || (/\d{1}/ =~ params[:password]).nil?
      flash[:failure] = "Password Must Contain One Number and One Special Character"
      redirect '/signup'
    elsif params[:password] != params[:confirm_password]
      flash[:failure] = "Passwords do not match"
      redirect '/signup'
    else
      @user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = @user.id
      redirect to "/#{@user.slug}"
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/reports'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/#{@user.slug}"
    else
      flash[:failure] = "Unable to Authenticate Username and Password. Please Try Again."
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:success] = "You have been logged out."
      redirect '/'
    else
      redirect '/'
    end
  end

  get '/:slug' do
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end


end
