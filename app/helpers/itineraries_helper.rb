module ItinerariesHelper

  def delete_activity_from_itinerary(itinerary_id, activity_id)
    Itinerary.find(itinerary_id).activities.delete(Activity.find(activity_id))
  end
end
