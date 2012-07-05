Kip - The Family Itinerary App
===

Kip is an itinerary app designed to turn your LivingSocial Families deal into a fantastic day for the entire family.

Installation
---
1. Clone the repo
2. Bundle install, rake db:migrate & rake db:test:prepare
3. Set up the config file. First, go to http://www.yelp.com/developers/ and if you do not have one already, create an API key. You need one for their API V2.

In main_config.rb:

    CONSUMER_KEY = "Yelp Consumer Key"
    CONSUMER_SECRET = "Yelp Consumer Secret"
    TOKEN = "Yelp Token"
    TOKEN_SECRET = "Yelp Token Secret"
    
You may also specify your search categories by setting CATEGORIES to be more or less specfic.

    Set ADMIN_EMAIL to equal your main email address. A user account with that email will be able to load new deals and activities.

3. 'rails server' to run the app

Setting Up the App
---
1. Go to the URL you've launched at, usually localhost:3000
2. Create an account using the admin login and sign in
3. Load the deals
    Go to /family_deals and click the link 'Update deals'
    Click the button 'Generate New Deals'
4. Create the activities
    Go to /activities and click 'Add Additional Activities'
    Click the button 'Create Activities from Deals'

Using the App (Users)
---
1. Go to the URL you've launched, if it's running locally it is likely at localhost:3000
2. Create an account if you do not have one already.
3. Click the dark blue 'Create Itinerary' button.
4. Give your itinerary a name.
5. Select the deal that you want to build the day around.
6. Pick the activities you'd like to add to your day. As you pick them, they will be added to the map.
7. When you are done picking activities, click 'save itinerary' to view the completed plan.

You can view a list of all your itineraries at the root of the app when logged in.


Tests
---
Tests are rspec, bundle exec rspec to run.

