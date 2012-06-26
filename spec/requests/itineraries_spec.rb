require 'spec_helper'

describe "Itineraries" do
  before(:each) do 
    visit itineraries_path
  end

  context "when there are no itineraries" do
    it "should instruct the user to create an itinerary" do
      page.should have_content("create an itinerary")
    end
  end

  describe "creating an itinerary" do
    it "has a link to create an itinerary" do
      page.should have_content("Create itinerary")
    end

    it "has a form to create an itinerary" do
      click_link_or_button("Create itinerary")
      page.should have_selector("#new_itinerary")
    end

    it "Creates an itinerary" do
      current_itinerary_count = Itinerary.count
      click_link_or_button("Create itinerary")
      fill_in :name, with: "Test Itinerary"
      click_link_or_button("Save Itinerary")
      Itinerary.count.should == current_itinerary_count + 1
    end

    describe "building an itinerary when activities exist" do
      let!(:activity_one) { FactoryGirl.create(:activity, name: "Activity One") }
      let!(:activity_two) { FactoryGirl.create(:activity, name: "Activity Two") }
      let!(:activity_three) { FactoryGirl.create(:activity, name: "Activity Three") }
      let!(:itinerary) { FactoryGirl.create(:itinerary) }

      it "has a list of activities associated with that itinerary" do
        pending "Needs reworking post-redesign"
        visit itinerary_path(itinerary.id)
        page.should have_content(activity_one.name)
        page.should have_content(activity_two.name)
        page.should have_content(activity_three.name)
      end

      it "adds the item to the itinerary when the add button is clicked" do
        pending "Needs reworking"
        visit itinerary_path(itinerary.id)
        click_link_or_button("Add #{activity_one.name} to itinerary")
        within("#itinerary") do
          page.should have_content(activity_one.name)
        end
      end

      it "does not include added items in the list of activities to select"

    end

  end

  context "when there is at least one itinerary" do
    let!(:itinerary_one) {FactoryGirl.create(:itinerary, name: "Itinerary One")}
    let!(:itinerary_two) {FactoryGirl.create(:itinerary, name: "Itinerary Two")}
    let!(:itinerary_three) {FactoryGirl.create(:itinerary, name: "Itinerary Three")}

    before(:each) do
      visit itineraries_path
    end

    it "Returns the correct number of itineraries" do
      Itinerary.count.should == 3
    end

    it "Lists the itineraries" do
      page.should have_content "Itinerary One"
      page.should have_content "Itinerary Two"
      page.should have_content "Itinerary Three"
    end

    describe "clicking on an itinerary" do
      it "Takes you to the details page for the itinerary" do
        click_link_or_button "Itinerary One"
        page.should have_content("Itinerary One")
      end

      it "allows the user to delete the itinerary" do
        visit itinerary_path(itinerary_one.id)
        click_link_or_button "Delete"
        page.should_not have_content("Itinerary One")
      end
    end
  end

end