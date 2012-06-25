class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :country
      t.string :phone

      t.timestamps
    end
  end
end
