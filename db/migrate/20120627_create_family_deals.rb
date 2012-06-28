class CreateFamilyDeals < ActiveRecord::Migration
  def change
    create_table :family_deals do |t|
      t.string  :ls_id
      t.string  :link
      t.string  :title
      t.string  :long_title
      t.string  :deal_type
      t.string  :merchandise_type
      t.string  :market_id
      t.string  :market_name
      t.string  :market_location
      t.string  :featureType
      t.string  :country_code
      t.string  :subtitle
      t.string  :image_url
      t.string  :categories
      t.string  :address1
      t.string  :address2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :country

      t.timestamps
    end
  end
end