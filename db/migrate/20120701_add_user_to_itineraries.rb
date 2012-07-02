class AddUserToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :user_id,  :integer
  end
end