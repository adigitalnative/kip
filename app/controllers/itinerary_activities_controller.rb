
class ItineraryActivitiesController < ApplicationController

  def new
    @itinerary_activity = ItineraryActivity.new
  end
end
