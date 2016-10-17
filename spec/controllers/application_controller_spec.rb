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
      report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave.", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: 01/02/2016, borough_id: 1, user_id: user.id)
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

    it "allows you to create a new user" do
      visit '/signup'
      fill_in :username, :with => "michaelscott"
      fill_in :password, :with => "password123"
      click_button "Create Account"
      expect(User.all.count).to eq(1)
    end


    it "redirects user to user show page after signup" do
      params = {
        :username => "thingonthewing",
        :password => "password123"
      }
      post '/signup', params
      @user = User.find_by(username: params[:username])
      expect(last_response.location).to include("/users/#{@user.slug}")
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

    it 'does not let a signed up user view the signup page' do
      params = {
        :username => "skittles123",
        :password => "rainbows"
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
      it 'shows user new tweet form if logged in' do
        user = User.create(:username => "mrbigglez", :password => "katzen")

        visit '/login'

        fill_in(:username, :with => "mrbigglez")
        fill_in(:password, :with => "katzen")
        click_button 'submit'
        visit '/reports/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a report if they are logged in' do
        user = User.create(:username => "mrbigglez", :password => "katzen")

        visit '/login'

        fill_in(:username, :with => "mrbigglez")
        fill_in(:password, :with => "katzen")
        click_button 'submit'

        visit 'reports/new'
        fill_in(:title, :with => "Ben and Jerries Ice Cream")
        fill_in(:business, :with => "Starbucks")
        fill_in(:location, :with => "146 Rikers Street")
        fill_in(:date, :with => "2016-09-12")
        fill_in(:content, :with => "Some great food")

        report = Report.find_by(content: "Some great food")
        expect(report).to be_instance_of(Report)
        expect(report.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end
    end
  end

end
