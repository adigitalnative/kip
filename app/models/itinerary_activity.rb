class ItineraryActivity < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :itinerary
  belongs_to :activity
end
