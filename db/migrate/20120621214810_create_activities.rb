class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :country
      t.string :phone
      t.string :categories
      t.string :image_url
      t.string :link
      t.integer :deal_activity_id
      t.boolean :deal, default: false
      t.boolean :deal_activities_built, default: false

      t.timestamps
    end
  end
end