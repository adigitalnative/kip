
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
    @mapped_activities = @activities
    @json = @mapped_activities.to_gmaps4rails
  end

  def new
    @itinerary = Itinerary.new
    @deals = Activity.find_all_by_deal(true)
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

    build_available_activities
    build_current_activities

    @deals = Activity.find_all_by_deal(true)
  end

  def update
    @itinerary = Itinerary.find(params[:id])
    @activity = Activity.find(params[:itinerary][:activity_id])
    @itinerary.activities << @activity

    flash[:message] = "#{@activity.name} added to #{@itinerary.name}"
    redirect_to edit_itinerary_path(@itinerary)
  end

  private

  def get_families_deals
    deal = FamilyDeal.all
    deal.first
  end

  def build_current_activities
    @current_activities.each do |activity|
      if activity.deal = true
        @deal = activity
      end
    end
  end

  def build_available_activities
    @available_activities = []
    all_activities = Activity.all
    all_activities.each do |activity|
      if activity.deal == false
        unless @current_activities.include?(activity)
          @available_activities << activity
        end
      end
    end
  end

end
