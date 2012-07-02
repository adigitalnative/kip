module ItinerariesHelper


  def itinerary_photo_url(id)
    activities = Itinerary.find(id).activities
    deal_activity = nil
    activities.each do |activity|
      if activity.deal == true
        deal_activity = activity
      end
    end
    if deal_activity
      deal_activity.image_url
    end
  end

  def deal_name(itinerary_id)
    activities = Itinerary.find(itinerary_id).activities
    deal_activity = nil
    activities.each do |activity|
      if activity.deal == true
        deal_activity = activity
      end
    end
    deal_activity
  end

end
