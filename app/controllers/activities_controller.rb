
class ActivitiesController < ApplicationController
  def index
    @activities = Activity.find_all_by_deal(false)
    @json = @activities.to_gmaps4rails
  end
end
