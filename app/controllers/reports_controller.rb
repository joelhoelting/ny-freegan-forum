class ReportsController < ApplicationController

  get '/reports/new' do
    if logged_in?
      @user = User.find(session[:user_id ])
      erb :'reports/new'
    end
  end

  post '/new' do
    binding.pry
  end

end
