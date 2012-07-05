
class ItinerariesController < ApplicationController
  def index
    unless current_user
      redirect_to new_user_session_path
    else
      @itineraries = Itinerary.find_all_by_user_id(current_user.id)
      if @itineraries == []
        @empty_message = "You haven't created any itineraries yet! Why don't you get started?"
      end
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

    redirect_to edit_itinerary_path(@itinerary)
  end

  def destroy
    @itinerary = Itinerary.find(params[:id])
    @itinerary.destroy
    redirect_to itineraries_path
  end

  def edit
    @itinerary = Itinerary.find(params[:id])
    @current_activities = @itinerary.activities

    @deal = @deal || this_itinerary_deal
    if @deal
      build_available_activities(@deal.id)
    end

    @deals = Activity.find_all_by_deal(true)

    @activity_map = @current_activities.to_gmaps4rails
  end

  def update
    @itinerary = Itinerary.find(params[:id])
    @activity = Activity.find(params[:itinerary][:activity_id])
    @itinerary.activities << @activity

    flash[:message] = "#{@activity.name} added to #{@itinerary.name}"
    redirect_to edit_itinerary_path(@itinerary)
  end

  private

  def this_itinerary_deal
    deal = @current_activities.each do |activity|
      if activity.deal == true
        activity
      end
    end
    deal = deal.first
  end

  def build_available_activities(deal_id)
    @available_activities = []
    all_activities = Activity.find_all_by_deal_activity_id(deal_id)
    all_activities.each do |activity|
      if activity.deal == false 
        unless @current_activities.include?(activity)
          @available_activities << activity
        end
      end
    end
  end

end
