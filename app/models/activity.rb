class Activity < ActiveRecord::Base
  # attr_accessible :title, :body

  acts_as_gmappable

  def gmaps4rails_address
    "#{self.street}, #{self.city}, #{self.country}"
  end

  def gmaps4rails_infowindow
    "
      <h3>#{self.name}</h3>
      <img src='#{self.image_url}' style='float:left;'>
      <div>
        <p>#{self.street}</p>
        <p><a href='#{self.link}'>More Information</a></p>
      </div>
    "
  end

end
