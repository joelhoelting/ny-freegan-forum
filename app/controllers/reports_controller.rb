class ReportsController < ApplicationController

  get '/reports' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    @reports = Report.all
    erb :'reports/index'
  end

  get '/reports/new' do
    if logged_in?
      @user = User.find(session[:user_id ])
      erb :'reports/new'
    else
      flash[:failure] = "Please login to create a report"
      redirect '/login'
    end
  end

  post '/reports/new' do
    if params[:title].nil? || params[:title].length < 3 || params[:business].nil? || params[:business].length < 3 || params[:location].nil? || params[:location].length < 3 || params[:content].nil? || params[:content].length < 3 || params[:date].nil? || params[:date].length < 3 || params[:borough].nil?
      flash[:failure] = "Please do not leave any forms blank"
      redirect to '/reports/new'
    elsif params[:title].downcase == "bronx" || params[:title].downcase == "brooklyn" || params[:title].downcase == "manhattan" || params[:title].downcase == "queens" || params[:title].downcase == "staten island" || params[:title].downcase == "statenisland"
      flash[:failure] = "Title is not acceptable"
      redirect to '/reports/new'
    elsif (/(19|20)\d\d[- \/.](0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])/ =~ params[:date]) != 0
      flash[:failure] = "Date must follow proper format: YYYY-MM-DD"
      redirect to '/reports/new'
    elsif params[:date] > DateTime.now.to_date.strftime("%Y/%m/%d")
      binding.pry
      flash[:failure] = "Date must be present or past. Did you build a time machine?"
      redirect to 'reports/new'
    else
      @user = User.find_by(id: session[:user_id])
      @borough = Borough.find_by(name: params[:borough])
      @report = Report.create(title: params[:title], business: params[:business], location: params[:location], content: params[:content], date: params[:date], user_id: @user.id, borough_id: @borough.id)
      redirect to "/reports/#{@report.slug}"
    end
  end

  ### Boroughs Controller ###

  get '/reports/bronx' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    @bronx = Borough.find_by(name: "Bronx")
    @reports = @bronx.reports.all
    erb :'/boroughs/bronx'
  end

  get '/reports/brooklyn' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    @brooklyn = Borough.find_by(name: "Brooklyn")
    @reports = @brooklyn.reports.all
    erb :'/boroughs/brooklyn'
  end

  get '/reports/manhattan' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    @manhattan = Borough.find_by(name: "Manhattan")
    @reports = @manhattan.reports.all
    erb :'/boroughs/manhattan'
  end

  get '/reports/queens' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    @queens = Borough.find_by(name: "Queens")
    @reports = @queens.reports.all
    erb :'/boroughs/queens'
  end

  get '/reports/staten_island' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    @staten_island = Borough.find_by(name: "Staten Island")
    @reports = @staten_island.reports.all
    erb :'/boroughs/staten_island'
  end

  ### End Boroughs Controller ###

  get '/reports/:slug' do
    @report = Report.find_by_slug(params[:slug])
    if logged_in?
      @user = User.find(session[:user_id])
    end
    if (session[:user_id] == @report.user_id) && @report.user_id != nil
      erb :'/reports/show_edit_delete'
    else
      erb :'/reports/show'
    end
  end

  get '/reports/:slug/edit' do
    if logged_in?
      @report = Report.find_by_slug(params[:slug])
      if session[:user_id] == @report.user_id
        @user = User.find(@report.user_id)
        erb :'/reports/edit'
      else
        flash[:failure] = "You cannot edit another user's report"
        redirect to "/#{User.find(session[:user_id]).slug}"
      end
    else
      redirect to '/login'
    end
  end

  patch '/reports/:slug' do
    if params[:title].nil? || params[:title].length < 3 || params[:business].nil? || params[:business].length < 3 || params[:location].nil? || params[:location].length < 3 || params[:content].nil? || params[:content].length < 3 || params[:date].nil? || params[:date].length < 3 || params[:borough].nil?
      flash[:failure] = "Please do not leave any forms blank"
      redirect to "/reports/#{params[:slug]}/edit"
    elsif (/(19|20)\d\d[- \/.](0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])/ =~ params[:date]) != 0
      flash[:failure] = "Date must follow proper format: YYYY-MM-DD"
      redirect to "/reports/#{params[:slug]}/edit"
    else
      @report = Report.find_by_slug(params[:slug])
      @report.title = params[:title]
      @report.business = params[:business]
      @report.location = params[:location]
      @report.content = params[:content]
      @report.date = params[:date]
      @report.borough = Borough.find_by(name: params[:borough])
      @report.save
      redirect to "/reports/#{@report.slug}"
    end
  end

  delete '/reports/:slug/delete' do
    @user = User.find(session[:user_id])
    @report = Report.find_by_slug(params[:slug])
    if @report != nil && logged_in? && @report.user_id == session[:user_id]
      @report.destroy
      redirect to "/#{@user.slug}"
    else
      redirect to "/#{@user.slug}"
    end
  end


end
