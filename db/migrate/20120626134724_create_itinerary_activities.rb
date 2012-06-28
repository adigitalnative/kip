class CreateItineraryActivities < ActiveRecord::Migration
  def change
    create_table :itinerary_activities do |t|
      t.integer :itinerary_id

      t.timestamps
    end
  end
end
