require 'spec_helper'

describe "FamilyDeals" do

  context "Logged in as admin" do
    let!(:user) { FactoryGirl.create(:user) }
    before(:each) do
      visit root_path
      fill_in 'Email', with: 'adigitalnative@gmail.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
    end

    describe "#index" do
      let!(:deal_one) { FactoryGirl.create(:family_deal) }
      let!(:deal_two) { FactoryGirl.create(:family_deal) }

      before(:each) { visit family_deals_path }

      it "displays deals in the system" do
        page.should have_content(deal_one.long_title)
      end

      it "has the correct number of deals" do
        FamilyDeal.all.count.should == 2
      end
    end

    describe "#new" do
      before(:each){ visit new_family_deal_path }

      it "should have a list of today's deals" do
        page.should have_selector("#family_deals")
      end

    end

  end

  context "Logged in as non-admin" do
    let!(:user) { FactoryGirl.create(:user, email: "jacqueline.chenault@livingsocial.com")}
    before(:each) do
      visit root_path
      fill_in 'Email', with: 'jacqueline.chenault@livingsocial.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
    end

    describe "#index" do
      it "takes you to the itinerary list" do
        visit family_deals_path
        page.should have_selector("#itinerary_title")
      end
    end

    describe "#new" do
      it "takes you to the itinerary list" do
        visit new_family_deal_path
        page.should have_selector("#itinerary_title")
      end
    end
  end

end