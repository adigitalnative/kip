require 'spec_helper'

describe 'activities' do
  context "when signed on as admin" do
    let!(:user) { FactoryGirl.create(:user) }

    before(:each) do
      visit root_path
      fill_in 'Email', with: 'adigitalnative@gmail.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
    end


    context "when there are activities" do
      let!(:activity_one) { FactoryGirl.create(:activity, name: "Activity One") }
      let!(:activity_two) { FactoryGirl.create(:activity, name: "Activity Two") }
      
      before(:each) { visit activities_path }

      it "has a list of the activities" do
        page.should have_content(activity_one.name)
        page.should have_content(activity_two.name)
      end
    end

    context "creating new activities" do
      before(:each) { visit new_activity_path }

      it "is false" do
        page.should have_selector("#build_activities")
      end
    end
  end

  context "when not signed in as admin" do
    let!(:second_user) { FactoryGirl.create(:user, email: "jacqueline.chenault@livingsocial.com") }
    before(:each) do
      visit root_path
      fill_in 'Email', with: 'jacqueline.chenault@livingsocial.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
    end

    it "#new redirects to itineraries" do
      visit new_activity_path
      page.should have_selector("#itinerary_title")
    end

    it "#index redirects to itineraries" do
      visit activities_path
      page.should have_selector("#itinerary_title")
    end
  end
end