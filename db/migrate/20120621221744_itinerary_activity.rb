class ItineraryActivity < ActiveRecord::Migration
  def change
    create_table :itinerary_activity do |t|
      t.integer :itinerary_id
      t.integer :activity_id      
    end
  end
end
