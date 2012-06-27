
class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    @json = Activity.all.to_gmaps4rails
  end
end
