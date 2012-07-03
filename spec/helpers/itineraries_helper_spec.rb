require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ItinerariesHelper. For example:
#
# describe ItinerariesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ItinerariesHelper do
  let!(:itinerary) { FactoryGirl.create(:itinerary) }
    let!(:activity_one) { FactoryGirl.create(:activity, deal: true, image_url: "foo", name: "A Deal")}
    before(:each) do
      itinerary.activities << activity_one
    end

  describe "itinerary_photo_url" do
    
    it "provides an image url" do
      itinerary_photo_url(itinerary.id).should == "foo"
    end
  end

  describe "deal_name" do
    it "provides the deal name associated with the itinerary" do
      deal_name(itinerary.id).name.should == "A Deal"
    end
  end
end
