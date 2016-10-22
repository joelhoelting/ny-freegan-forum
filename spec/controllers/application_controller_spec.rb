require 'spec_helper'

describe ApplicationController do

  describe "Preliminary Setup" do
    it "displays the home page" do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("website to inform and connect nyc freegans")
    end


    it "displays the index page" do
      get '/reports'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("NY Freegan Forum")
      expect(last_response.body).to include("Reports")
      expect(last_response.body).to include("Log In")
      expect(last_response.body).to include("Sign Up")
    end


    it 'shows all the reports submitted by the user' do
      user = User.create(username: "gijoeler", password: "monkeybusiness")
      report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave.", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: 1, user_id: user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include(report.title)
      expect(last_response.body).to include(report.content)
      expect(last_response.body).to include(user.username)
    end
  end

  describe 'User Authentication' do
    context "Signup Page" do
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

    context 'Login Page' do
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

    context 'Logout Page' do
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
  end

  describe 'Create Action' do

    context 'Logged In' do
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

    context 'Logged Out' do
      it 'user not logged in cannot access new report page' do
        get '/reports/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Read Action' do
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

    it 'displays show page of the new report with a link to edit' do
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

    it 'report show page only shows edit link to user who created it' do
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
      expect(last_response.body).not_to include("Edit")
    end
  end

  describe 'Update Action' do
    context 'Logged In' do
      before do
        @user = User.create(:username => "michaelscott567", :password => "kittens123$")
        @user1 = User.create(:username => "mrbigglez", :password => "katzen134$")
        @user2 = User.create(:username => "jameston", :password => "townies123$")
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

      it 'lets a user view report edit form if they are logged in' do

        report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user.id)
        visit '/login'

        fill_in(:username, :with => "michaelscott567")
        fill_in(:password, :with => "kittens123$")
        click_button 'Login'
        visit "/reports/#{report.slug}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(report.content)
      end

      it 'does not let a user edit a report they did not create' do
        report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user.id)

        visit '/login'

        fill_in(:username, :with => "mrbigglez")
        fill_in(:password, :with => "katzen134$")
        click_button 'Login'
        session = {}
        session[:user_id] = @user1.id
        visit "/reports/#{report.slug}/edit"
        expect(page.current_path).to include("/users/#{@user1.slug}")
        expect(page.body).to include("You cannot edit another user's report")
      end

      it 'lets a user edit their own report if they are logged in' do
        report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user.id)
        visit '/login'

        fill_in(:username, :with => "michaelscott567")
        fill_in(:password, :with => "kittens123$")
        click_button 'Login'
        visit "/reports/#{report.slug}/edit"

        fill_in(:title, :with => "I just changed the title")
        fill_in(:content, :with => "I just changed the content of this report")
        choose("Staten Island")

        click_button 'Edit'
        expect(Report.find_by(:title => "I just changed the title")).to be_instance_of(Report)
        expect(Report.find_by(:content => "I just changed the content of this report")).to be_instance_of(Report)
        expect(Report.find_by(:title => "Organic Vegan Dark Chocolate")).to eq(nil)

        expect(page.status_code).to eq(200)
        expect(page.body).to include("I just changed the title")
      end

      it 'gives an error if edits contain any blank or nil fields' do
        report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user.id)
        visit '/login'

        fill_in(:username, :with => "michaelscott567")
        fill_in(:password, :with => "kittens123$")
        click_button 'Login'
        visit "/reports/#{report.slug}/edit"

        fill_in(:title, :with => "12")
        fill_in(:content, :with => "")
        choose("Queens")

        click_button 'Edit'
        expect(Report.find_by(:title => "Organic Vegan Dark Chocolate")).to be_instance_of(Report)
        expect(page.current_path).to eq('/reports/organic-vegan-dark-chocolate-1/edit')
      end
    end

    context 'Logged Out' do
      before do
        @user = User.create(:username => "michaelscott567", :password => "kittens123$")
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
      it 'does not let user view edit form if not logged in' do
        report = Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user.id)
        get "/reports/#{report.slug}/edit"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Delete Action' do
    context "Logged In" do
      before do
        @user = User.create(:username => "michaelscott567", :password => "kittens123$")
        @user1 = User.create(:username => "mrbigglez", :password => "katzen134$")
        @user2 = User.create(:username => "jameston", :password => "townies123$")
        Borough.create(name: "Brooklyn")
        Borough.create(name: "Bronx")
        Borough.create(name: "Manhattan")
        Borough.create(name: "Queens")
        Borough.create(name: "Staten Island")
        Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user2.id)
        Report.create(title: "Brownie Bonanza", business: "Hipster's Bakery Paradise", location: "22 Hipster Ave, Williamsburg, Brooklyn", content: "Found some amazing brownies!", date: "2016-12-12", borough_id: Borough.find_by(name: "Brooklyn").id, user_id: @user.id)

      end
      after do
        User.destroy_all
        Borough.destroy_all
      end

      it 'lets a user delete their own report if they are logged in' do
        visit '/login'

        fill_in(:username, :with => "jameston")
        fill_in(:password, :with => "townies123$")
        click_button 'Login'

        visit "/reports/#{Report.find_by(title: "Organic Vegan Dark Chocolate").slug}"
        expect(page.body).to include("Delete")
        click_button 'Delete'
        expect(page.status_code).to eq(200)
        expect(Report.find_by(:title => "Organic Vegan Dark Chocolate")).to eq(nil)
        expect(page.current_path).to eq("/users/#{@user2.slug}")
      end

      it "doesn't let a user delete a report they did not create" do
        visit '/login'

        params = {
          :username => "jameston",
          :password => "townies123$"
        }
        post '/login', params
        follow_redirect!

        Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user2.id)
        visit "/reports/#{Report.find_by(title: "Organic Vegan Dark Chocolate").slug}"
        expect(page.body).not_to include("Delete")
        expect(Report.find_by(:title => "Organic Vegan Dark Chocolate")).to be_instance_of(Report)
      end
    end
    context "Logged Out" do
      before do
        @user2 = User.create(:username => "jameston", :password => "townies123$")
        Borough.create(name: "Brooklyn")
        Borough.create(name: "Bronx")
        Borough.create(name: "Manhattan")
        Borough.create(name: "Queens")
        Borough.create(name: "Staten Island")
        Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2016-09-12", borough_id: Borough.find_by(name: "Manhattan").id, user_id: @user2.id)
      end
      after do
        User.destroy_all
        Borough.destroy_all
        Report.destroy_all
      end
      it "lets you see report show page of another user but not delete it" do
        get "/reports/#{Report.find_by(title: "Organic Vegan Dark Chocolate").slug}"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("Log In")
        expect(last_request.url).to eq("http://example.org/reports/organic-vegan-dark-chocolate-1")
      end
    end
  end

end
