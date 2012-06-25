
class ItinerariesController < ApplicationController
  def index
    @itineraries = Itinerary.all
    if @itineraries == []
      @empty_message = "There are no itineraries. Perhaps you should create an itinerary?"
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @activities = Activity.all
  end

  def new
    @itinerary = Itinerary.new
  end

  def create
    @itinerary = Itinerary.new(params[:itinerary])
    @itinerary.save

    flash[:message] = "Itinerary Created"

    redirect_to itinerary_path(@itinerary)
  end

  def destroy
    @itinerary = Itinerary.find(params[:id])
    @itinerary.destroy
    redirect_to itineraries_path
  end
end
