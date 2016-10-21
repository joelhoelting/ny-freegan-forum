class ReportsController < ApplicationController

  get '/reports/new' do
    if logged_in?
      @user = User.find(session[:user_id ])
      erb :'reports/new'
    else
      flash[:message] = "Please login to create a report"
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
      redirect to "/reports/#{@report.slug}"
    end
  end

  get '/reports/:slug' do
    @report = Report.find_by_slug(params[:slug])
    if logged_in?
      @user = User.find(session[:user_id])
    end
    if (session[:user_id] == @report.user_id) && @report.user_id != nil
      erb :'reports/show_and_edit'
    else
      erb :'reports/show'
    end
  end

  get '/reports/:slug/edit' do
    @report = Report.find_by_slug(params[:slug])
    @user = User.find(@report.user_id)
    erb :'/reports/edit'
  end

  # patch '/reports/:id' do
  #   if params[:content] == "" || params[:content] == " " || params[:content].length < 2
  #     flash[:message] = "Tweet cannot be empty"
  #     redirect to "/tweets/#{params[:id]}/edit"
  #   else
  #     @tweet = Tweet.find(params[:id])
  #     @tweet.content = params[:content]
  #     @tweet.save
  #     redirect to "/tweets/#{@tweet.id}"
  #   end
  # end


end
