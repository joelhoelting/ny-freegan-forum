require 'spec_helper'

describe ApplicationController do

  describe "Home" do
    it "displays the home page" do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("website to inform and connect nyc freegans")
    end
  end

  describe "Reports" do
    it "displays the index page" do
      get '/reports'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("NY Freegan Forum")
      expect(last_response.body).to include("Reports")
      expect(last_response.body).to include("Log In")
      expect(last_response.body).to include("Sign Up")
    end
  end

  describe "User profile page" do
    it 'shows all the reports submitted by the user' do
      user = User.create(username: "gijoeler", password: "monkeybusiness")
      report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave.", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: 1, user_id: user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Organic Vegan Dark Chocolate")
      expect(last_response.body).to include("employees at this grocery store")
      expect(last_response.body).to include(user.username)
    end
  end

  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it "signup page lets user know it wants password w/ minimum 6 characters, with one number and one special character" do
      get '/signup'
      expect(last_response.body).to include ("minimum six characters, 1 number and 1 special character")
    end

    it 'rejects username less than 6 characters and show one-time error message' do
      params = {
        :username => "alex",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
      follow_redirect!
      expect(last_response.body).to include("Username must be six or more characters")
    end

    it 'rejects password less than 6 characters and show one-time error message' do
      params = {
        :username => "alexscott",
        :password => "rain"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
      follow_redirect!
      expect(last_response.body).to include("Password must be six or more characters")
    end

    it 'password must contain one number and one non-alphanumeric character' do
      params = {
        :username => "alexscott",
        :password => "rain1"
      }
      post '/signup', params
      follow_redirect!
      expect(last_request.url).to eq("http://example.org/signup")
      expect(last_response.body).to include("minimum six characters, 1 number and 1 special character")
    end

    it 'cannot signup if username already exists' do
      User.create(username: "alexthegreat", password: "pasword134!#{}")
      params = {
        username: "alexthegreat",
        password: "wikileaks123$"
      }
      post '/signup', params
      follow_redirect!
      expect(last_request.url).to eq("http://example.org/signup")
      expect(last_response.body).to include("Username is already taken")
    end

    it "allows you to create a new user" do
      visit '/signup'
      fill_in :username, :with => "michaelscott"
      fill_in :password, :with => "password123$!#"
      click_button "Signup"
      expect(User.all.count).to eq(1)
    end


    it "redirects user to user show page after signup" do
      params = {
        :username => "thingonthewing",
        :password => "password123#"
      }
      post '/signup', params
      @user = User.find_by(username: params[:username])
      expect(last_response.location).to include("/users/#{@user.slug}")
    end

    it 'does not let a signed up user view the signup page' do
      params = {
        :username => "skittles123",
        :password => "rainbows1341%"
      }
      post '/signup', params
      session = {}
      session[:user_id] = User.find_by(username: "skittles123").id
      get '/signup'
      expect(last_response.location).to include('/')
    end
  end

  describe 'Login Page' do
    before do
      @user = User.create(username: "MrBigglesworth", password: "funnycat123")
    end

    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'redirects to user show page after login' do
      params = {
        :username => "MrBigglesworth",
        :password => "funnycat123"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      expect(last_response.location).to eq("http://example.org/users/mrbigglesworth")
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("#{@user.username}")
    end

    it 'index page has link to create new report after login' do
      params = {
        :username => "MrBigglesworth",
        :password => "funnycat123"
      }
      post '/login', params
      follow_redirect!
      expect(last_response.body).to include('a href="/reports/new"')
    end

    it 'gives a one-time error message if login details cannot authenticate' do
      params = {
        :username => "MrBglesworth",
        :password => "funnycat123"
      }
      post '/login', params
      expect(last_response.location).to include('/login')
      follow_redirect!
      expect(last_response.body).to include("Unable to authenticate username/password")
    end

    it 'does not let user view login page if already logged in' do
      params = {
        :username => "MrBigglesworth",
        :password => "funnycat123"
      }
      post '/login', params
      session = {}
      session[:user_id] = @user.id
      get '/login'
      expect(last_response.location).to eq("http://example.org/reports")
    end
  end

  describe 'Logout' do
    before do
      @user = User.create(:username => "becky567", :password => "kittens")
    end
    it 'lets a user logout if they are logged in' do
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to eq("http://example.org/")
    end

    it 'gives a one-time message alerting user they are logged out' do
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      follow_redirect!
      expect(last_response.body).to include("You have been logged out.")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to eq("http://example.org/")
    end
  end

  describe 'Creating a New report' do
    context 'logged in' do

      before do
        @user = User.create(:username => "mrbigglez", :password => "katzen")
        @user1 = User.create(:username => "jameston", :password => "townies")
        @user2 = User.create(:username => "stallone420", :password => "hunde")
        Borough.create(name: "Brooklyn")
        Borough.create(name: "Bronx")
        Borough.create(name: "Manhattan")
        Borough.create(name: "Queens")
        Borough.create(name: "Staten Island")
      end

      after do
        User.destroy_all
        Borough.destroy_all
      end

      it 'can show user view new report form if logged in' do
        visit '/login'

        fill_in(:username, :with => "mrbigglez")
        fill_in(:password, :with => "katzen")
        click_button 'Login'
        visit '/reports/new'
        expect(page.status_code).to eq(200)
      end

      it 'user gets redirected to login page if not logged in and tries to create new report' do
        get '/reports/new'
        expect(last_response.location).to eq("http://example.org/login")
      end

      it 'lets user create a report if they are logged in' do
        visit '/login'

        fill_in(:username, :with => "mrbigglez")
        fill_in(:password, :with => "katzen")
        click_button "Login"

        visit '/reports/new'
        fill_in(:title, :with => "Ben and Jerries Ice Cream")
        fill_in(:business, :with => "Starbucks")
        fill_in(:location, :with => "146 Rikers Street")
        fill_in(:content, :with => "Some great food")
        fill_in(:date, :with => "2016-09-12")
        choose("Manhattan")

        click_button "Create"

        @report = Report.find_by(:content => "Some great food")
        expect(Report.all.count).to eq(1)
        expect(@report.user_id).to eq(@user.id)
        expect(@report.borough.name).to eq('Manhattan')
      end

      it 'does not let a user create a report from another user' do
        visit '/login'

        fill_in(:username, :with => "jameston")
        fill_in(:password, :with => "townies")
        click_button 'Login'

        visit '/reports/new'

        fill_in(:title, :with => "Cinnamon Bun Heaven")
        fill_in(:business, :with => "Cinnabon")
        fill_in(:location, :with => "146 Douglas Ave")
        fill_in(:content, :with => "Super sticky buns")
        fill_in(:date, :with => "2016-07-22")
        choose("Manhattan")

        click_button "Create"

        report = Report.find_by(:content => "Super sticky buns")
        expect(report).to be_instance_of(Report)
        expect(report.user_id).to eq(@user1.id)
        expect(report.user_id).not_to eq(@user2.id)
      end

      it 'user gets error if new report has any blank or nil parameters' do
        params = {
          :username => "jameston",
          :password => "townies"
        }
        post '/login', params
        follow_redirect!
        params = {
          :title => "jameston",
          :business => "townies",
          :location => "122",
          :content => "Some content is placed here",
          :date => "2016-07-12"
        }
        post '/reports/new', params
        follow_redirect!
        expect(last_request.url).to eq("http://example.org/reports/new")
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Please do not leave any forms blank")
      end

      it 'date of new report must follow correct format (YYYY-MM-DD)' do
        params = {
          :username => "jameston",
          :password => "townies"
        }
        post '/login', params
        follow_redirect!
        params = {
          :title => "jameston",
          :business => "townies",
          :location => "122 Styvuesant Street",
          :content => "Some content is placed here",
          :date => "03-03-2016",
          :borough => "Manhattan"
        }
        post '/reports/new', params
        follow_redirect!
        expect(last_request.url).to eq("http://example.org/reports/new")
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Date must follow proper format: YYYY-MM-DD")
      end
    end
  end

  describe 'show action' do
    before do
      @user = User.create(:username => "mrbigglez", :password => "katzen134$")
      @user1 = User.create(:username => "jameston", :password => "townies123$")
      @user2 = User.create(:username => "stallone420", :password => "hound123$")
      Borough.create(name: "Brooklyn")
      Borough.create(name: "Bronx")
      Borough.create(name: "Manhattan")
      Borough.create(name: "Queens")
      Borough.create(name: "Staten Island")
    end

    after do
      User.destroy_all
      Borough.destroy_all
    end

    it 'displays show page of the new report with an option to edit' do
      params = {
        :username => "mrbigglez",
        :password => "katzen134$"
      }
      post '/login', params
      follow_redirect!

      params = {
        :title => "Watermelon Madness",
        :business => "Food Emporium",
        :location => "122 Styvuesant Street",
        :content => "Some content is placed here",
        :date => "2016-03-03",
        :borough => "Manhattan"
      }
      post '/reports/new', params
      follow_redirect!
      report = Report.find_by(title: "Watermelon Madness")
      expect(last_request.url).to eq("http://example.org/reports/watermelon-madness-1")
      expect(last_response.body).to include(report.title)
      expect(last_response.body).to include("Edit")
    end

    it 'report show page cannot be edited by another user' do
      params = {
        :username => "mrbigglez",
        :password => "katzen134$"
      }
      post '/login', params
      follow_redirect!

      params = {
        :title => "Watermelon Madness",
        :business => "Food Emporium",
        :location => "122 Styvuesant Street",
        :content => "Some content is placed here",
        :date => "2016-03-03",
        :borough => "Manhattan"
      }
      post '/reports/new', params
      follow_redirect!
      report = Report.find_by(title: "Watermelon Madness")
      get '/logout'

      params = {
        :username => "jameston",
        :password => "townies123$"
      }
      post '/login', params
      follow_redirect!
      get "/reports/#{report.slug}"
      (last_response.body).should_not include("Edit")
    end

  end

end
