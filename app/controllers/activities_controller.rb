class ActivitiesController < ApplicationController
  def index
    if current_user.email == "adigitalnative@gmail.com"
      @activities = Activity.find_all_by_deal(false)
      @deals = Activity.find_all_by_deal(true)
      @json = @activities.to_gmaps4rails
    else
      redirect_to root_path
    end
  end

  def new
    if current_user.email == "adigitalnative@gmail.com"
      @activity = Activity.new
    else
      redirect_to root_path
    end
  end

  def create
    if current_user.email == "adigitalnative@gmail.com"
      @deals_without_yelp_activities = unyelped_deals
      @deals_without_yelp_activities.each do |deal|
        city = deal.city.split.join("+")
        yelp_activities = yelp_query(city)
        build_yelp_activities(yelp_activities, deal.id)
        mark_as_yelped(deal)
      end
      redirect_to activities_path
    else
      redirect_to root_path
    end
  end

  private

  #TODO: Move the set of these to an initializer
  CONSUMER_KEY = "7QsDS8wC4bDb7hVpRksBTg"
  SECRET = "y-lCC8eFxjpk6EszM4ndzOtN_wc"
  TOKEN = "3ysbGiBfWEVIeFI4fjHkRvA45MnSIjTm"
  TOKEN_SECRET = "nrVpYNr9qrkPvvbKqjQztpzCSdw"
  CATEGORIES = ["amusementparks", "aquariums", "beaches", "gokarts",
    "kiteboarding", "lakes", "mini_golf", "paddleboarding", "parks", "playgrounds",
    "rafting", "recreation", "skatingrinks", "surfing", "zoos", "arcades",
    "galleries", "gardens", "movietheaters", "museums", "bakeries",
    "farmersmarket", "gelato", "icecream", "candy", "restaurants"].join(",")

  def mark_as_yelped(deal)
    activity = Activity.find(deal.id)
    activity.deal_activities_built == true
    activity.save
  end

  def yelp_activities(deals)
    deals.each do |deal|
      city = deal.city.split.join("+")
      yelp_activities = yelp_query(city)
      build_yelp_activities(yelp_activities, deal.id)
      mark_as_yelped(deal)
    end
  end

  def yelp_query(location)
    consumer = OAuth::Consumer.new(CONSUMER_KEY, SECRET, {site: "http://api.yelp.com", signature_method: "HMAC-SHA1", scheme: :query_string})
    access_token = OAuth::AccessToken.new(consumer, TOKEN, TOKEN_SECRET)
    yelp_activities = JSON.parse(access_token.get("/v2/search?location=#{location}&category_filter=#{CATEGORIES}").body)
    yelp_activities["businesses"]
  end

  def unyelped_deals
    deals = []
    Activity.find_all_by_deal(true).each do |activity|
      if activity.deal_activities_built == false
        deals << activity
      end
    end
    deals
  end

  def build_yelp_activities(yelp_activities, deal_id)
    yelp_activities.each do |activity|
      new_activity = Activity.new
      new_activity.deal_activity_id = deal_id
      new_activity.name = activity["name"]
      new_activity.street = activity["location"]["address"]
      new_activity.city = activity["location"]["city"]
      new_activity.country = activity["location"]["country_code"]
      new_activity.latitude = activity["location"]["coordinate"]["latitude"]
      new_activity.longitude = activity["location"]["coordinate"]["longitude"]
      new_activity.categories = activity["categories"]
      new_activity.image_url = activity["image_url"]
      new_activity.link = activity["url"]
      new_activity.save
    end
  end

  # Sample Yelp queries for when Yelp is rate-limited
  # def yelp_query_recorded(location)
  #   dc_results = [  {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/yelps-caribbean-carnival-876-cafe-washington", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>27, "name"=>"Yelp's Caribbean Carnival @ 876 Cafe", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/t4W6npeOu79kNw9W_QYMSQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/yelps-caribbean-carnival-876-cafe-washington", "snippet_text"=>"**Notices review is still in \"draft\" mode**\n\nDammit!!!!\n\nWell with those pleasantries aside, on to the very belated review!\n---------------\nLet me bid a...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/LSAYyzDS1Q6_JX6V2lBgUQ/ms.jpg", "categories"=>[["Local Flavor", "localflavor"]], "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"yelps-caribbean-carnival-876-cafe-washington", "is_closed"=>false, "location"=>{"cross_streets"=>"N Van Ness St & N Window Pl", "city"=>"Washington", "display_address"=>["4221-B Connecticut Ave", "(b/t N Van Ness St & N Window Pl)", "Van Ness/Forest Hills", "Washington, DC 20008"], "geo_accuracy"=>8, "neighborhoods"=>["Van Ness/Forest Hills"], "postal_code"=>"20008", "country_code"=>"US", "address"=>["4221-B Connecticut Ave"], "coordinate"=>{"latitude"=>38.9437623, "longitude"=>-77.0630127}, "state_code"=>"DC"}}, 
  #                   {"is_claimed"=>true, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/dr-david-bronat-washington", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>24, "name"=>"Dr. David Bronat", "snippet_image_url"=>"http://media3.ak.yelpcdn.com/static/201206261986305257/img/gfx/blank_user_medium.gif", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/dr-david-bronat-washington", "phone"=>"2022961601", "snippet_text"=>"I am a very picky patient, but I am nothing but satisfied with Dr. Bronat. He is very personable and he remembers me and my pain each time I come in - I'm...", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/HomRJIjY_PmMQrAgTmg2Og/ms.jpg", "categories"=>[["Chiropractors", "chiropractors"]], "display_phone"=>"+1-202-296-1601", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"dr-david-bronat-washington", "is_closed"=>false, "location"=>{"cross_streets"=>"N Lingers Ct & N M St", "city"=>"Washington", "display_address"=>["1145 19th St NW", "#308", "(b/t N Lingers Ct & N M St)", "Washington, DC 20036"], "geo_accuracy"=>8, "postal_code"=>"20036", "country_code"=>"US", "address"=>["1145 19th St NW", "#308"], "coordinate"=>{"latitude"=>38.905054, "longitude"=>-77.042893}, "state_code"=>"DC"}},
  #                   {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/vietnam-veterans-memorial-washington", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>115, "name"=>"Vietnam Veterans Memorial", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/YCNhjE-OfAbiZaPO3g2-bQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/vietnam-veterans-memorial-washington", "phone"=>"2024266841", "snippet_text"=>"For years I've driven down Constitution Avenue and never knew this memorial was there, because it is not visible from the street. \n\nAbout ten year ago, I...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/nIp72-oBbPSCgknCEvg-JQ/ms.jpg", "categories"=>[["Landmarks & Historical Buildings", "landmarks"]], "display_phone"=>"+1-202-426-6841", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"vietnam-veterans-memorial-washington", "is_closed"=>false, "location"=>{"city"=>"Washington", "display_address"=>["National Mall", "Henry Bacon Dr and Constitution Ave NW", "Washington, DC 20050"], "geo_accuracy"=>7, "postal_code"=>"20050", "country_code"=>"US", "address"=>["National Mall", "Henry Bacon Dr and Constitution Ave NW"], "coordinate"=>{"latitude"=>38.8921094, "longitude"=>-77.0480512}, "state_code"=>"DC"}},
  #                   {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/korean-war-veterans-memorial-washington", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>82, "name"=>"Korean War Veterans Memorial", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/YCNhjE-OfAbiZaPO3g2-bQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/korean-war-veterans-memorial-washington", "phone"=>"2024266841", "snippet_text"=>"I've been to the Korean War Veterans Memorial several times and each time I get chills. The larger than life statues are in the positions they would have...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/yQ2E4bYbLNPj9JvvmnWm2Q/ms.jpg", "categories"=>[["Landmarks & Historical Buildings", "landmarks"]], "display_phone"=>"+1-202-426-6841", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"korean-war-veterans-memorial-washington", "is_closed"=>false, "location"=>{"city"=>"Washington", "display_address"=>["Lincoln Memorial Circle Southwest", "23rd St SW near Ohio Drive SW and Independence Ave SW", "Washington, DC 20037"], "geo_accuracy"=>7, "postal_code"=>"20037", "country_code"=>"US", "address"=>["Lincoln Memorial Circle Southwest", "23rd St SW near Ohio Drive SW and Independence Ave SW"], "coordinate"=>{"latitude"=>38.8872237, "longitude"=>-77.0501398}, "state_code"=>"DC"}}
  #                 ]
  # end

  # def yelp_activities_stub(location)
  #   {"region"=>{"span"=>{"latitude_delta"=>0.23990594267662146, "longitude_delta"=>0.22701039915037313}, "center"=>{"latitude"=>29.4697088557621, "longitude"=>-98.50013834506835}}, "total"=>7207, "businesses"=>[{"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/sol-y-luna-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>23, "name"=>"Sol Y Luna", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/H94xaNoQIou9I25GWLFJ5Q/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/sol-y-luna-san-antonio", "phone"=>"2104925777", "snippet_text"=>"I held in my hand a real, scrumptious, hefty kolache. They don't kid around about their portions. This ain't no commercial Kolache Factory with wimpy...", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/K2INMKLvaTgVTSWI8mkRNQ/ms.jpg", "categories"=>[["Bakeries", "bakeries"]], "display_phone"=>"+1-210-492-5777", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"sol-y-luna-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["4421 De Zavala Rd", "San Antonio, TX 78249"], "geo_accuracy"=>8, "postal_code"=>"78249", "country_code"=>"US", "address"=>["4421 De Zavala Rd"], "coordinate"=>{"latitude"=>29.5713388, "longitude"=>-98.5734428}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/ranger-creek-brewing-and-distilling-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>34, "name"=>"Ranger Creek Brewing & Distilling", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/c6wGNFed4PCyxyBrUf6Emg/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/ranger-creek-brewing-and-distilling-san-antonio", "phone"=>"2107752099", "snippet_text"=>"I can't believe I haven't done a review for Ranger Creek yet. \n\nWell, my first experience with Ranger Creek was at Alamo Drafthouse, I asked for a local...", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/mI-luQWWYCUSu245ST2Y8w/ms.jpg", "categories"=>[["Breweries", "breweries"]], "display_phone"=>"+1-210-775-2099", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"ranger-creek-brewing-and-distilling-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["4834 Whirlwind Dr", "San Antonio, TX 78217"], "geo_accuracy"=>8, "postal_code"=>"78217", "country_code"=>"US", "address"=>["4834 Whirlwind Dr"], "coordinate"=>{"latitude"=>29.5295495, "longitude"=>-98.3969518}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/mcnay-art-museum-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>57, "name"=>"McNay Art Museum", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/hN3PBs0-eCtLDIPEKL1BWA/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/mcnay-art-museum-san-antonio", "phone"=>"2108245368", "snippet_text"=>"In 1950 Marion McNay passed away and left here 24 room 1927 Spanish Colonial Mansion, 23 acres of land, more than 700 pieces of art and an endowment to...", "image_url"=>"http://s3-media3.ak.yelpcdn.com/bphoto/94qvODCjNYZVLOiHSqO7zw/ms.jpg", "categories"=>[["Museums", "museums"]], "display_phone"=>"+1-210-824-5368", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"mcnay-art-museum-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["6000 N New Braunfels Ave", "San Antonio, TX 78209"], "geo_accuracy"=>8, "postal_code"=>"78209", "country_code"=>"US", "address"=>["6000 N New Braunfels Ave"], "coordinate"=>{"latitude"=>29.485132, "longitude"=>-98.458159}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/lululemon-athletica-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>18, "name"=>"lululemon athletica", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/D6Wv39_pMbORVAD09iRbTw/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/lululemon-athletica-san-antonio", "phone"=>"2108220017", "snippet_text"=>"My sister got me hooked on Lulu's products. I recently finally got myself Wunder Under leggings and the staff there was extremely helpful and supportive....", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/N0xOE8babFAybf606_wBlA/ms.jpg", "categories"=>[["Yoga", "yoga"], ["Sports Wear", "sportswear"], ["Women's Clothing", "womenscloth"]], "display_phone"=>"+1-210-822-0017", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"lululemon-athletica-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["255 E Basse Rd", "Ste 410", "San Antonio, TX 78209"], "geo_accuracy"=>8, "postal_code"=>"78209", "country_code"=>"US", "address"=>["255 E Basse Rd", "Ste 410"], "coordinate"=>{"latitude"=>29.4972, "longitude"=>-98.482547}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/mission-san-jose-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>23, "name"=>"Mission San Jose", "snippet_image_url"=>"http://s3-media1.ak.yelpcdn.com/photo/i75NZcF5ZuWx6qnjT0Zzuw/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/mission-san-jose-san-antonio", "phone"=>"2109321001", "snippet_text"=>"I had the fortunate pleasure of joining Brett B and his daughter for a morning here recently. It's got to be one of the most beautiful places in San Antonio...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/AmF9Pv9LCOmKnzKF5tAb7Q/ms.jpg", "categories"=>[["Churches", "churches"], ["Landmarks & Historical Buildings", "landmarks"]], "display_phone"=>"+1-210-932-1001", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"mission-san-jose-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["6710 San Jose Dr", "San Antonio, TX 78214"], "geo_accuracy"=>8, "postal_code"=>"78214", "country_code"=>"US", "address"=>["6710 San Jose Dr"], "coordinate"=>{"latitude"=>29.3606607, "longitude"=>-98.4785416}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/los-cocos-fruteria-y-taqueria-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>22, "name"=>"Los Cocos Fruteria Y Taqueria", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/aZEzRXZzxK13__Hof198BA/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/los-cocos-fruteria-y-taqueria-san-antonio", "phone"=>"2104317786", "snippet_text"=>"Mmmm.....Ahh.... \n\n...are the sounds I make when I take a sip of their delicious aqua fresca! On a hot day, I am determined to get some of that delicious...", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/oD6XvM4LqlYqncsrpI6LoQ/ms.jpg", "categories"=>[["Mexican", "mexican"], ["Juice Bars & Smoothies", "juicebars"]], "display_phone"=>"+1-210-431-7786", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"los-cocos-fruteria-y-taqueria-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["1502 Bandera Rd", "San Antonio, TX 78228"], "geo_accuracy"=>8, "postal_code"=>"78228", "country_code"=>"US", "address"=>["1502 Bandera Rd"], "coordinate"=>{"latitude"=>29.4670476, "longitude"=>-98.5673851}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/paciugo-gelato-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>37, "name"=>"Paciugo Gelato", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/XcEe5kGcf1Bj4qmlr0vSvA/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/paciugo-gelato-san-antonio", "phone"=>"2108328820", "snippet_text"=>"Our initial annoyance with the line at Amy's ice cream at the Quarry led us here to Paciugo (as well as it's proximity to Sushi Zushi!). The quality of the...", "image_url"=>"http://s3-media3.ak.yelpcdn.com/bphoto/GBQ19CWSObZv9o8JWwOpBg/ms.jpg", "categories"=>[["Ice Cream & Frozen Yogurt", "icecream"]], "display_phone"=>"+1-210-832-8820", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"paciugo-gelato-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["999 E Basse Rd", "Ste 196", "San Antonio, TX 78209"], "geo_accuracy"=>9, "postal_code"=>"78209", "country_code"=>"US", "address"=>["999 E Basse Rd", "Ste 196"], "coordinate"=>{"latitude"=>29.491893, "longitude"=>-98.4785239}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/el-paraiso-ice-cream-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>12, "name"=>"El Paraiso Ice Cream", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/Ln4mYfwYjC6qp9FWQO_Nzg/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/el-paraiso-ice-cream-san-antonio", "phone"=>"2107378101", "snippet_text"=>"Two words: Coconut Paleta.\n\nAs much as I love traditional ice cream and froyo, I'd choose fruit paletas over them any day. They're inexpensive, tasty, and...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/F_MRt7s-loYj71DK6NYZEw/ms.jpg", "categories"=>[["Ice Cream & Frozen Yogurt", "icecream"]], "display_phone"=>"+1-210-737-8101", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"el-paraiso-ice-cream-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["1934 Fredericksburg Rd", "San Antonio, TX 78201"], "geo_accuracy"=>8, "postal_code"=>"78201", "country_code"=>"US", "address"=>["1934 Fredericksburg Rd"], "coordinate"=>{"latitude"=>29.463524, "longitude"=>-98.524617}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/beijing-express-restaurant-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>14, "name"=>"Beijing Express Restaurant", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/81G5ZBbR64yx1XGKwAj1Vw/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/beijing-express-restaurant-san-antonio", "phone"=>"2104969858", "snippet_text"=>"Tried the Kung Pao chicken - outstanding!\n\nLots of red and green pepper, plenty of a nice sauce, generous amounts of chicken - very nice!", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/C6CGWzzxnw-ZZgx5Zep7sw/ms.jpg", "categories"=>[["Chinese", "chinese"]], "display_phone"=>"+1-210-496-9858", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"beijing-express-restaurant-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["13730 Embassy Row", "San Antonio, TX 78216"], "geo_accuracy"=>8, "postal_code"=>"78216", "country_code"=>"US", "address"=>["13730 Embassy Row"], "coordinate"=>{"latitude"=>29.5653132, "longitude"=>-98.4855013}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/society-bakery-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>15, "name"=>"Society Bakery", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/aN_zkgM5jTCfS_PPuT6Q_g/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/society-bakery-san-antonio", "phone"=>"2148271411", "snippet_text"=>"So I finally had a cupcake from Society Bakery Yall! Or should I say cupcakes. After dinner at Boardwalk on Bulverde I was too stuff to indulge in a cupcake...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/IcJB0CdLBOwEk5wYPgsx8w/ms.jpg", "categories"=>[["Street Vendors", "streetvendors"], ["Bakeries", "bakeries"]], "display_phone"=>"+1-214-827-1411", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"society-bakery-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["14732 Bulverde", "San Antonio, TX 78247"], "geo_accuracy"=>8, "postal_code"=>"78247", "country_code"=>"US", "address"=>["14732 Bulverde"], "coordinate"=>{"latitude"=>29.575413, "longitude"=>-98.417073}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/joes-hamburger-place-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>16, "name"=>"Joe's Hamburger Place", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/sM_rTIyCSxjot12G0utjeQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/joes-hamburger-place-san-antonio", "phone"=>"2107330542", "snippet_text"=>"I found this place on Yelp.  I will admit, I live on Blanco and it took me a little while to find it because there are no signs and it looks like an...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/uQfCgAyv4-ZgGfNWvAJ_lQ/ms.jpg", "categories"=>[["Burgers", "burgers"]], "display_phone"=>"+1-210-733-0542", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"joes-hamburger-place-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["2423 Blanco Rd", "San Antonio, TX 78212"], "geo_accuracy"=>8, "postal_code"=>"78212", "country_code"=>"US", "address"=>["2423 Blanco Rd"], "coordinate"=>{"latitude"=>29.4693438, "longitude"=>-98.5078702}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/ruths-chris-steak-house-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>27, "name"=>"Ruth's Chris Steak House", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/hZSRUR7vRgRvG7mi04adFw/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/ruths-chris-steak-house-san-antonio", "phone"=>"2108215051", "snippet_text"=>"Got the juicy t bone medium on a sizzling hot plate. You may burn your fingers so be careful! Lol Buttery goodness. I spent about $300 for 3 people. I...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/jUhWBCiD1gY890wVZTiCyQ/ms.jpg", "categories"=>[["Steakhouses", "steak"]], "display_phone"=>"+1-210-821-5051", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"ruths-chris-steak-house-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["7720 Jones Maltsberger Rd", "San Antonio, TX 78216"], "geo_accuracy"=>8, "postal_code"=>"78216", "country_code"=>"US", "address"=>["7720 Jones Maltsberger Rd"], "coordinate"=>{"latitude"=>29.5045072, "longitude"=>-98.4817163}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/rickshaw-stop-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>43, "name"=>"Rickshaw Stop", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/mjUtcZueY_g7JCugKyooYA/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/rickshaw-stop-san-antonio", "phone"=>"2109029308", "snippet_text"=>"Rickshaw Stop is DELICIOUS.\n\nDefinitely one of our favorite trucks at BoB. Almost everytime we go we HAVE to get samosas if nothing else. They are fantastic...", "image_url"=>"http://s3-media3.ak.yelpcdn.com/bphoto/gQYyJeixR1dr8A7eapCYng/ms.jpg", "categories"=>[["Pakistani", "pakistani"], ["Street Vendors", "streetvendors"]], "display_phone"=>"+1-210-902-9308", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"rickshaw-stop-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["14732 Bulverde Rd", "San Antonio, TX 78247"], "geo_accuracy"=>8, "postal_code"=>"78247", "country_code"=>"US", "address"=>["14732 Bulverde Rd"], "coordinate"=>{"latitude"=>29.575413, "longitude"=>-98.417073}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/thai-cafe-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>66, "name"=>"Thai Cafe", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/ZbL2d7wGvtCHHjmgg8ALfQ/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/thai-cafe-san-antonio", "phone"=>"2105998830", "snippet_text"=>"Followed Rudy R.'s advice and this was most excellent Thai.  And a buffet?  \n\nWe tried everything today for lunch and loved it all.    Awesome!   Tried 8...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/46uLjnQTekXQoNrkAjZhXQ/ms.jpg", "categories"=>[["Thai", "thai"]], "display_phone"=>"+1-210-599-8830", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"thai-cafe-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["11318 Perrin Beitel Rd", "San Antonio, TX 78217"], "geo_accuracy"=>8, "postal_code"=>"78217", "country_code"=>"US", "address"=>["11318 Perrin Beitel Rd"], "coordinate"=>{"latitude"=>29.542801, "longitude"=>-98.410595}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/jamaica-jamaica-cuisine-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>23, "name"=>"Jamaica Jamaica Cuisine", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/hN3PBs0-eCtLDIPEKL1BWA/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/jamaica-jamaica-cuisine-san-antonio", "phone"=>"2104467986", "snippet_text"=>"Send your taste buds on a trip to the islands without leaving San Antonio!\n\nStop reading this review and just go. Great atmosphere, friendly service and...", "image_url"=>"http://s3-media3.ak.yelpcdn.com/bphoto/t7U_p-n-uaVaVC2C8dY06Q/ms.jpg", "categories"=>[["Caribbean", "caribbean"]], "display_phone"=>"+1-210-446-7986", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"jamaica-jamaica-cuisine-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["2011 Austin Hwy", "San Antonio, TX 78218"], "geo_accuracy"=>8, "postal_code"=>"78218", "country_code"=>"US", "address"=>["2011 Austin Hwy"], "coordinate"=>{"latitude"=>29.5025248, "longitude"=>-98.4182254}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/phil-hardberger-park-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>36, "name"=>"Phil Hardberger Park", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/LyrrnB0TexOf-8tLCxQyOA/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/phil-hardberger-park-san-antonio", "phone"=>"2102073284", "snippet_text"=>"Dog Park!!!\nAs the proud owner of a Great Dane and a Rat Terrier dog parks are our sanctuary. I have a giant who thinks he's a Chihuaha, and a terrier with...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/9KGmAIWutCxZI59mUm8izQ/ms.jpg", "categories"=>[["Dog Parks", "dog_parks"]], "display_phone"=>"+1-210-207-3284", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"phil-hardberger-park-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["13203 Blanco Rd", "San Antonio, TX 78216"], "geo_accuracy"=>8, "postal_code"=>"78216", "country_code"=>"US", "address"=>["13203 Blanco Rd"], "coordinate"=>{"latitude"=>29.5638659, "longitude"=>-98.519915}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/japanese-tea-gardens-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>37, "name"=>"Japanese Tea Gardens", "snippet_image_url"=>"http://s3-media1.ak.yelpcdn.com/photo/O0nJ09ySVrd56HcXuZBnLg/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/japanese-tea-gardens-san-antonio", "phone"=>"2107350663", "snippet_text"=>"I don't know what they did to fix this up, but THANK YOU.  Five or six years ago, this place was looking pretty shabby.  I was enjoying it on some kind of...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/q3ZGayxNjEJojFBFZj6foA/ms.jpg", "categories"=>[["Botanical Gardens", "gardens"]], "display_phone"=>"+1-210-735-0663", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"japanese-tea-gardens-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["3853 N St. Mary's St", "San Antonio, TX 78212"], "geo_accuracy"=>8, "postal_code"=>"78212", "country_code"=>"US", "address"=>["3853 N St. Mary's St"], "coordinate"=>{"latitude"=>29.460197, "longitude"=>-98.4766412}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/chelas-tacos-san-antonio-2", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>27, "name"=>"Chela's Tacos", "snippet_image_url"=>"http://s3-media4.ak.yelpcdn.com/photo/_XlrCgRp_69EsnOPlvTfFQ/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/chelas-tacos-san-antonio-2", "phone"=>"2105357340", "snippet_text"=>"We were in the middle of buying a new Hyundai Sonata Hybrid from Ted at Red McCombs which turned out to be a great car and sold to us by a knowledgable and...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/9ynlyRc4MIJ4iPKbwGPcwA/ms.jpg", "categories"=>[["Tex-Mex", "tex-mex"], ["Food Stands", "foodstands"], ["Mexican", "mexican"]], "display_phone"=>"+1-210-535-7340", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"chelas-tacos-san-antonio-2", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["Utex Blvd", "14531 Roadrunner Way", "San Antonio, TX 78249"], "geo_accuracy"=>9, "postal_code"=>"78249", "country_code"=>"US", "address"=>["Utex Blvd", "14531 Roadrunner Way"], "coordinate"=>{"latitude"=>29.5787570115242, "longitude"=>-98.6033248901367}, "state_code"=>"TX"}}, {"is_claimed"=>false, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/the-big-bib-san-antonio", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>61, "name"=>"The Big Bib", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/b_xTi-4IUk5dOwmYlSMyoA/ms.jpg", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/the-big-bib-san-antonio", "phone"=>"2106548400", "snippet_text"=>"Freaking Awesome!! That's really all I Can say. We are here on business and came here on a tip from a local friend and some yelp investigating... \nThe Big...", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/zAnqi8rHfr601FQcxbBmtA/ms.jpg", "categories"=>[["Barbeque", "bbq"]], "display_phone"=>"+1-210-654-8400", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"the-big-bib-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["2427 Austin Hwy", "San Antonio, TX 78218"], "geo_accuracy"=>8, "postal_code"=>"78218", "country_code"=>"US", "address"=>["2427 Austin Hwy"], "coordinate"=>{"latitude"=>29.5097637, "longitude"=>-98.4084792}, "state_code"=>"TX"}}, {"is_claimed"=>true, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/spice-runner-san-antonio", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>13, "name"=>"Spice Runner", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/mjUtcZueY_g7JCugKyooYA/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/spice-runner-san-antonio", "phone"=>"2818518160", "snippet_text"=>"Oh my heavenly God. I love Spice Runner.\n\nI've read the reviews on here about how good their ribs are, so when I saw them on the specials board Friday...", "image_url"=>"http://s3-media3.ak.yelpcdn.com/bphoto/9ju4k_2y__YvPFX6CzN3UA/ms.jpg", "categories"=>[["Street Vendors", "streetvendors"], ["Sandwiches", "sandwiches"]], "display_phone"=>"+1-281-851-8160", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"spice-runner-san-antonio", "is_closed"=>false, "location"=>{"city"=>"San Antonio", "display_address"=>["14732 Bulverde Rd", "San Antonio, TX 78247"], "geo_accuracy"=>8, "postal_code"=>"78247", "country_code"=>"US", "address"=>["14732 Bulverde Rd"], "coordinate"=>{"latitude"=>29.575413, "longitude"=>-98.417073}, "state_code"=>"TX"}}]}
  # end
end
