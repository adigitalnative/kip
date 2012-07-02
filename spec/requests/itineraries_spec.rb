require 'spec_helper'

describe "Itineraries" do
  let!(:user) { FactoryGirl.create(:user) }

  before(:each) do
    visit root_path
    fill_in 'Email', with: 'adigitalnative@gmail.com'
    fill_in 'Password', with: 'hungry'
    click_link_or_button("Sign in") 
    visit itineraries_path
  end

  context "when there are no itineraries" do
    it "instructs user to create an itinerary" do
      page.should have_selector("#empty_itinerary_message")
    end

  end

  describe "when creating an itinerary" do
    it "has a link to create an itinerary" do
      page.should have_content("Create itinerary")
    end

    it "has a form to create an itinerary" do
      click_link_or_button("Create itinerary")
      page.should have_selector("#new_itinerary")
    end

    it "creates an itinerary" do
      pending "silly name on label issue!"
      current_itinerary_count = Itinerary.count
      click_link_or_button("Create itinerary")
      save_and_open_page
      fill_in "#name", with: "Test Itinerary"
      click_link_or_button("Save Itinerary")
      Itinerary.count.should == current_itinerary_count + 1
    end

    describe "when activities exist" do
      let!(:activity_one) { FactoryGirl.create(:activity, name: "Activity One") }
      let!(:activity_two) { FactoryGirl.create(:activity, name: "Activity Two") }
      let!(:activity_three) { FactoryGirl.create(:activity, name: "Activity Three") }
      let!(:itinerary) { FactoryGirl.create(:itinerary) }

      it "does not display activities not yet associated with the itinerary" do
        visit itinerary_path(itinerary.id)
        page.should_not have_content(activity_one.name)
        page.should_not have_content(activity_two.name)
        page.should_not have_content(activity_three.name)
      end

      # it "can add items to the itinerary" do
      #   pending "Redesign"
      #   visit edit_itinerary_path(itinerary.id)
      #   within("#activity_list") do
      #     within ("#activity_1")
      #   end
      #   click_link_or_button("Add #{activity_one.name} to itinerary")
      #   within("#itinerary") do
      #     page.should have_content(activity_one.name)
      #   end
      # end

    end

  end

  context "when there is at least one itinerary" do
    let!(:itinerary_one) {FactoryGirl.create(:itinerary, name: "Itinerary One", user_id: user.id)}
    let!(:itinerary_two) {FactoryGirl.create(:itinerary, name: "Itinerary Two", user_id: user.id)}
    let!(:itinerary_three) {FactoryGirl.create(:itinerary, name: "Itinerary Three", user_id: user.id)}

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

    describe "editing an itinerary" do
      before(:each) do
        visit edit_itinerary_path(itinerary_one.id)
      end

      it "asks you to pick a deal" do
        page.should have_selector("#deal_pick")
      end

    end
  end

end