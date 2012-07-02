class Itinerary < ActiveRecord::Base
  attr_accessible :id, :name, :ls_deal_id, :user_id

  has_many :itinerary_activities
  has_many :activities, :through => :itinerary_activities
end
