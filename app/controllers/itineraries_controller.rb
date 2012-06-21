
class ItinerariesController < ApplicationController
  def index
    @itineraries = Itinerary.all
    if @itineraries == []
      @empty_message = "There are no itineraries. Perhaps you should create an itinerary?"
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
  end
end
