
class ActivitiesController < ApplicationController
  def index
    @activities = Activity.find_all_by_deal(false)
    @deals = Activity.find_all_by_deal(true)
    @json = @activities.to_gmaps4rails
  end

  def new
    @activity = Activity.new
  end

  def create
    @deals_without_yelp_activities = unyelped_deals
    city = @deals_without_yelp_activities.third.city.split.join("+")
    # yelp_activities = yelp_query(city)
    yelp_activities = yelp_query_recorded(city)
    build_yelp_activities(yelp_activities, @deals_without_yelp_activities.first.id)
    deal = @deals_without_yelp_activities.first
    deal.deal_activities_built = true
    deal.save

    redirect_to activities_path
  end

  private

  #TODO: Move the set of these to an initializer
  CONSUMER_KEY = "7QsDS8wC4bDb7hVpRksBTg"
  SECRET = "y-lCC8eFxjpk6EszM4ndzOtN_wc"
  TOKEN = "3ysbGiBfWEVIeFI4fjHkRvA45MnSIjTm"
  TOKEN_SECRET = "nrVpYNr9qrkPvvbKqjQztpzCSdw"

  def yelp_query(location)
    consumer = OAuth::Consumer.new(CONSUMER_KEY, SECRET, {site: "http://api.yelp.com", signature_method: "HMAC-SHA1", scheme: :query_string})
    access_token = OAuth::AccessToken.new(consumer, TOKEN, TOKEN_SECRET)
    yelp_activities = JSON.parse(access_token.get("/v2/search?location=#{location}").body)
    # yelp_activities["businesses"]
  end

  def yelp_query_recorded(location)
    dc_results = [  {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/yelps-caribbean-carnival-876-cafe-washington", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>27, "name"=>"Yelp's Caribbean Carnival @ 876 Cafe", "snippet_image_url"=>"http://s3-media3.ak.yelpcdn.com/photo/t4W6npeOu79kNw9W_QYMSQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/yelps-caribbean-carnival-876-cafe-washington", "snippet_text"=>"**Notices review is still in \"draft\" mode**\n\nDammit!!!!\n\nWell with those pleasantries aside, on to the very belated review!\n---------------\nLet me bid a...", "image_url"=>"http://s3-media2.ak.yelpcdn.com/bphoto/LSAYyzDS1Q6_JX6V2lBgUQ/ms.jpg", "categories"=>[["Local Flavor", "localflavor"]], "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"yelps-caribbean-carnival-876-cafe-washington", "is_closed"=>false, "location"=>{"cross_streets"=>"N Van Ness St & N Window Pl", "city"=>"Washington", "display_address"=>["4221-B Connecticut Ave", "(b/t N Van Ness St & N Window Pl)", "Van Ness/Forest Hills", "Washington, DC 20008"], "geo_accuracy"=>8, "neighborhoods"=>["Van Ness/Forest Hills"], "postal_code"=>"20008", "country_code"=>"US", "address"=>["4221-B Connecticut Ave"], "coordinate"=>{"latitude"=>38.9437623, "longitude"=>-77.0630127}, "state_code"=>"DC"}}, 
                    {"is_claimed"=>true, "rating"=>4.5, "mobile_url"=>"http://m.yelp.com/biz/dr-david-bronat-washington", "rating_img_url"=>"http://media4.ak.yelpcdn.com/static/201206263106483837/img/ico/stars/stars_4_half.png", "review_count"=>24, "name"=>"Dr. David Bronat", "snippet_image_url"=>"http://media3.ak.yelpcdn.com/static/201206261986305257/img/gfx/blank_user_medium.gif", "rating_img_url_small"=>"http://media4.ak.yelpcdn.com/static/201206261127761206/img/ico/stars/stars_small_4_half.png", "url"=>"http://www.yelp.com/biz/dr-david-bronat-washington", "phone"=>"2022961601", "snippet_text"=>"I am a very picky patient, but I am nothing but satisfied with Dr. Bronat. He is very personable and he remembers me and my pain each time I come in - I'm...", "image_url"=>"http://s3-media1.ak.yelpcdn.com/bphoto/HomRJIjY_PmMQrAgTmg2Og/ms.jpg", "categories"=>[["Chiropractors", "chiropractors"]], "display_phone"=>"+1-202-296-1601", "rating_img_url_large"=>"http://media2.ak.yelpcdn.com/static/201206262752244354/img/ico/stars/stars_large_4_half.png", "id"=>"dr-david-bronat-washington", "is_closed"=>false, "location"=>{"cross_streets"=>"N Lingers Ct & N M St", "city"=>"Washington", "display_address"=>["1145 19th St NW", "#308", "(b/t N Lingers Ct & N M St)", "Washington, DC 20036"], "geo_accuracy"=>8, "postal_code"=>"20036", "country_code"=>"US", "address"=>["1145 19th St NW", "#308"], "coordinate"=>{"latitude"=>38.905054, "longitude"=>-77.042893}, "state_code"=>"DC"}},
                    {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/vietnam-veterans-memorial-washington", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>115, "name"=>"Vietnam Veterans Memorial", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/YCNhjE-OfAbiZaPO3g2-bQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/vietnam-veterans-memorial-washington", "phone"=>"2024266841", "snippet_text"=>"For years I've driven down Constitution Avenue and never knew this memorial was there, because it is not visible from the street. \n\nAbout ten year ago, I...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/nIp72-oBbPSCgknCEvg-JQ/ms.jpg", "categories"=>[["Landmarks & Historical Buildings", "landmarks"]], "display_phone"=>"+1-202-426-6841", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"vietnam-veterans-memorial-washington", "is_closed"=>false, "location"=>{"city"=>"Washington", "display_address"=>["National Mall", "Henry Bacon Dr and Constitution Ave NW", "Washington, DC 20050"], "geo_accuracy"=>7, "postal_code"=>"20050", "country_code"=>"US", "address"=>["National Mall", "Henry Bacon Dr and Constitution Ave NW"], "coordinate"=>{"latitude"=>38.8921094, "longitude"=>-77.0480512}, "state_code"=>"DC"}},
                    {"is_claimed"=>false, "rating"=>5.0, "mobile_url"=>"http://m.yelp.com/biz/korean-war-veterans-memorial-washington", "rating_img_url"=>"http://media3.ak.yelpcdn.com/static/201206262578611207/img/ico/stars/stars_5.png", "review_count"=>82, "name"=>"Korean War Veterans Memorial", "snippet_image_url"=>"http://s3-media2.ak.yelpcdn.com/photo/YCNhjE-OfAbiZaPO3g2-bQ/ms.jpg", "rating_img_url_small"=>"http://media3.ak.yelpcdn.com/static/201206261949604803/img/ico/stars/stars_small_5.png", "url"=>"http://www.yelp.com/biz/korean-war-veterans-memorial-washington", "phone"=>"2024266841", "snippet_text"=>"I've been to the Korean War Veterans Memorial several times and each time I get chills. The larger than life statues are in the positions they would have...", "image_url"=>"http://s3-media4.ak.yelpcdn.com/bphoto/yQ2E4bYbLNPj9JvvmnWm2Q/ms.jpg", "categories"=>[["Landmarks & Historical Buildings", "landmarks"]], "display_phone"=>"+1-202-426-6841", "rating_img_url_large"=>"http://media1.ak.yelpcdn.com/static/20120626354709277/img/ico/stars/stars_large_5.png", "id"=>"korean-war-veterans-memorial-washington", "is_closed"=>false, "location"=>{"city"=>"Washington", "display_address"=>["Lincoln Memorial Circle Southwest", "23rd St SW near Ohio Drive SW and Independence Ave SW", "Washington, DC 20037"], "geo_accuracy"=>7, "postal_code"=>"20037", "country_code"=>"US", "address"=>["Lincoln Memorial Circle Southwest", "23rd St SW near Ohio Drive SW and Independence Ave SW"], "coordinate"=>{"latitude"=>38.8872237, "longitude"=>-77.0501398}, "state_code"=>"DC"}}
                  ]
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
      new_activity.save
    end
  end
end
