@user1 = User.create(:username => "Mr_Bigglesworth", :password => "katzen134$")
@user2 = User.create(:username => "Jamestown_Bro", :password => "townies123$")
@user3 = User.create(:username => "MichaelScott567", :password => "kittens123$")
@user4 = User.create(:username => "Yolo_Trump69", :password => "fakehair123%")
@user5 = User.create(:username => "SmoothCriminal", :password => "criminal123$")
@user6 = User.create(:username => "DolaMeister", :password => "password123$")

@brooklyn = Borough.create(name: "Brooklyn")
@bronx = Borough.create(name: "Bronx")
@manhattan = Borough.create(name: "Manhattan")
@queens = Borough.create(name: "Queens")
@staten_island = Borough.create(name: "Staten Island")

Report.create(title: "Ben and Jerries or Bust!", business: "Key Food", location: "60 St. Michael's Place", content: "My girlfriend and I were rollerblading at around 10pm. We went to the Flatbush Food Coop but had little success. A few blocks south there is a supermarket that throws away perfectly good food at closing time: around 11pm. We scored 10 cartons of Ben and Jerries and because it was late not many people took pictures of us!", date: "2016-06-29", borough_id: @staten_island.id, user_id: @user1.id)

Report.create(title: "Organic Baby Spinach in Bushwick", business: "Organic Mart", location: "455 Steinway St.", content: "We were walking around at around 10PM and we found some freshly tossed garbage bags filled with 10 sealed packages of organic baby spinach. I can't even afford this stuff brand new in the store. Salad is served for the next month!", date: "2016-08-21", borough_id: @brooklyn.id, user_id: @user2.id)

Report.create(title: "Organic Vegan Dark Chocolate", business: "Cindy's Organic Grocery Store", location: "122 Church Ave.", content: "At around 8pm, employees at this grocery store start taking out the trash. Some of the food is expired by a few days or weeks but it is still in good condition. We hit the jackpot with about 20 bars of vegan dark chocolate made in Chile. Each bar still had the price tag: $6 dollars per bar!", date: "2015-12-15", borough_id: @brooklyn.id, user_id: @user3.id)

Report.create(title: "Makeup Madness!", business: "Sephora", location: "Herald Square, NY, NY", content: "This was the easiest dive ever! I was shopping at Sephora and employees began filling up barbage bags right in front of me. It wasn't the most professional thing I've ever seen but whatever. I followed them outside and swan dived into the garbage. I scored $200 worth of makeup. I will never be ugly again!", date: "2016-12-12", borough_id: @manhattan.id, user_id: @user3.id)

Report.create(title: "Magical Stash of Books", business: "Strand Bookstore", location: "Union Sq. NY, NY", content: "Everybody knows that Strand has the discount books section in front of their store at all times. However, if you open a book called 'Open Sesame' a secret hatch will open in the sidewalk. When you go down the hatch you will have your dreams answered and there are free books!", date: "2016-04-13", borough_id: @manhattan.id, user_id: @user4.id)

Report.create(title: "Organic Cashews Chaos", business: "Flatbush Food Coop", location: "232 Mongoose Lane", content: "This dive will require guts and is of a legally dubious nature. List of items required: wirecutters, sodering iron, bolt-cutters, balls of steel. When the pitbulls finish their rounds cut through the outer fence. You will then need to use the sodering iron to cut a cut a hole in the next fence. Finally, you will see a gold dumpster up ahead. Use the bolt-cutters and you will be rewarded by an entire dumpster filled with Organic Icelandic cashews. I wasn't aware that cashews grew in Iceland, but I guess you learn something new every day!", date: "2015-08-21", borough_id: @brooklyn.id, user_id: @user1.id)

Report.create(title: "Panoply of Pitas", business: "Damascus Bakeries", location: "121 Eastern Ave, Brooklyn Bridge", content: "The pita goldmine is right outside the back entrance of this bakery. Just get there at around 9pm and you will have enough Pitas for the remainder of your time on this planet. Toast em, freeze em, make a blanket out of em. Anything is better than the garbage!", date: "2015-11-12", borough_id: @brooklyn.id, user_id: @user3.id)

Report.create(title: "Chinese Vegetables", business: "Tao's Vegetable Market", location: "11 Bay Street.", content: "There is a dark alley in the back of this market. Just be careful of the owner, this crazy old guy named Tao. He has some of the best vegetables in the city that get thrown away in a dumpster in the alley. Make sure you have good running shoes. If he sees you be prepared to run from him. He is extremely fast for a little man with a cane and he will be avenged if you steal his vegetables.", date: "2016-10-21", borough_id: @staten_island.id, user_id: @user3.id)

Report.create(title: "Pelham Pant Paradise", business: "Pascal's Pant Shop", location: "Van Cortland Pl.", content: "Custom made pants get thrown away each week at this store. Pascal is a nice guy and has elected to give away all his pants on a first-come, first-serve basis. Consider bringin a tent. Some of the grungiest freegans in the city line up a couple days early to get first dibs on these sweet threads.", date: "2016-10-12", borough_id: @bronx.id, user_id: @user6.id)

Report.create(title: "Bronx Hardware Heist", business: "Harold's Hardware", location: "12 James Street", content: "Found some perfectly good wrenches and screwdrivers outside of this hardware store in Manhattan. It was a pretty good haul, I also found some superglue which was great until it opened in my bag! Let's just say I won't be letting go of my bag any time because it is literally glued to me now!", date: "2016-03-11", borough_id: @bronx.id, user_id: @user4.id)

Report.create(title: "Dynamite Dates", business: "Al's Arabian Imports", location: "111 Egyptian Avenue", content: "I found some succullent organic dates outside of Al's Arabian Import shop. They were absolutely delicious and I would recommend anyone to go there if they are in the are during late night hours!", date: "2016-02-23", borough_id: @bronx.id, user_id: @user4.id)
