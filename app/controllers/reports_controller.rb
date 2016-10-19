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
    if params[:title].nil? || params[:title].length < 3 || params[:business].nil? || params[:business].length < 3 || params[:location].nil? || params[:location].length < 3 || params[:content].nil? || params[:content].length < 3 || params[:date].nil? || params[:date].length < 3 || params[:borough].nil?
      flash[:message] = "Please do not leave any forms blank"
      redirect to '/reports/new'
    elsif (/(19|20)\d\d[- \/.](0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])/ =~ params[:date]) != 0
      flash[:message] = "Date must follow proper format: YYYY-MM-DD"
      redirect to '/reports/new'
    else
      @user = User.find_by(id: session[:user_id])
      @borough = Borough.find_by(name: params[:borough])
      @report = Report.create(title: params[:title], business: params[:business], location: params[:location], content: params[:content], date: params[:date], user_id: @user.id, borough_id: @borough.id)
    end
  end

end
