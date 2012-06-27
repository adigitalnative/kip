
class ItinerariesController < ApplicationController
  def index
    @itineraries = Itinerary.all
    if @itineraries == []
      @empty_message = "There are no itineraries. Perhaps you should create an itinerary?"
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @activities = @itinerary.activities
    @json = @activities.to_gmaps4rails
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

  def edit
    @itinerary = Itinerary.find(params[:id])
    @current_activities = @itinerary.activities

    @available_activities = []
    all_activities = Activity.all
    all_activities.each do |activity|
      if @current_activities.include?(activity)
        #do nada
      else
        @available_activities << activity
      end
    end
  end

  def update
    @itinerary = Itinerary.find(params[:id])
    @activity = Activity.find(params[:itinerary][:activity_id])
    @itinerary.activities << @activity

    flash[:message] = "#{@activity.name} added to #{@itinerary.name}"
    redirect_to edit_itinerary_path(@itinerary)
  end

end
