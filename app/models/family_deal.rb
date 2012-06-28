class FamilyDeal < ActiveRecord::Base
  attr_accessible :ls_id, :link, :title, :long_title, :deal_type, :merchandise_type, :market_id, :market_name, :market_location, :featureType, :country_code, :subtitle, :image_url, :categories, :address1, :address2, :city, :state, :zip

end