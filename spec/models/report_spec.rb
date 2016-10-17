require 'spec_helper'

describe "Report" do
  before do
    @user1 = User.create(username: "jimmyjones545", password: "monkeybusiness")
    @user2 = User.create(username: "baby knight55", password: "knightly")

    @brooklyn = Borough.create(name: "Brooklyn")
    @bronx = Borough.create(name: "Bronx")
    @manhattan = Borough.create(name: "Manhattan")
    @queens = Borough.create(name: "Queens")
    @staten_island = Borough.create(name: "Staten Island")

    @report1 = Report.create(title: "Organic salad in Bushwick", business: "Organic Mart", location: "455 Steinway St.", content: "We were walking around at around 10PM and we found some freshly tossed bags filled with 10 sealed packages of organic baby spinach.", date: 01/02/2016, borough_id: 1, user_id: 1)
    @report2 = Report.create(title: "Brand new clothes left out every Tuesday", business: "American Apparel", location: "122 East 34th Street", content: "My friend works for AA and slipped me some information that they throw away brand new t-shirts in an alley every Tuesday.", date: 05/04/2016, borough_id: 3, user_id: 1)
    @report3 = Report.create(title: "Imported vegan dark chocolate", business: "Godiva", location: "Herald Square", content: "Just wait 30 minutes after closing and the employees toss away perfectly good chocolate. It's all sealed an only one day expired.", date: 13/06/2016, borough_id: 3, user_id: 2)
  end

  it "has a title" do
    expect(@report1.title).to eq("Organic salad in Bushwick")
  end

  it "has a location" do
    expect(@report3.location).to eq("Herald Square")
  end

  it "has a business" do
    expect(@report2.business).to eq("American Apparel")
  end

  it "has content" do
    expect(@report1.content).to include("at around 10PM")
  end

  it "has a date" do
    expect(@report2.date).to eq(05/04/2016)
  end

  it "belongs to a user" do
    expect(@report3.user).to eq(@user2)
  end

  it "belongs to a borough" do
    expect(@report1.borough).to eq(@brooklyn)
  end
end
