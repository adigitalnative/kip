class Activity < ActiveRecord::Base
  # attr_accessible :title, :body

  acts_as_gmappable

  def gmaps4rails_address
    "#{self.street}, #{self.city}, #{self.country}"
  end
end
