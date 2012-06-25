class Itinerary < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :itinerary_activities
  has_many :activities, :through => :itinerary_activities
end
