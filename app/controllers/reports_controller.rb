class ReportsController < ApplicationController

  get '/reports/new' do
    if logged_in?
      @user = User.find(session[:user_id ])
      erb :'reports/new'
    else
      redirect '/login'
    end
  end

  post '/reports/new' do
    @user = User.find_by(id: session[:user_id])
    @borough = Borough.find_by(name: params[:borough])
    @report = Report.create(title: params[:title], business: params[:business], location: params[:location], content: params[:content], date: params[:date], user_id: @user.id, borough_id: @borough.id)
    binding.pry
  end

end
