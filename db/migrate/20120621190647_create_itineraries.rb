class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.string  :name
      t.string  :itinerary_activity_id
      t.integer :ls_deal_id

      t.timestamps
    end
  end
end
