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
      flash[:message] = "Username is already taken"
      redirect '/signup'
    elsif params[:username].length < 6
      flash[:message] = "Username must be six or more characters."
      redirect '/signup'
    elsif params[:password].length < 6
      flash[:message] = "Password must be six or more characters"
      redirect '/signup'
    elsif (/[^\w]{1}/ =~ params[:password]).nil? || (/\d{1}/ =~ params[:password]).nil?
      flash[:message] = "Password must contain one number and one special character"
      redirect '/signup'
    else
      @user = User.create(username: params[:username], password: params[:password])
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
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
      redirect "/users/#{@user.slug}"
    else
      flash[:message] = "Unable to authenticate username/password, please try again."
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:message] = "You have been logged out."
      redirect '/'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end


end
