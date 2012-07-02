require 'spec_helper'

describe "FamilyDeals" do

  describe "#index" do
    let!(:deal_one) { FactoryGirl.create(:family_deal) }
    let!(:deal_two) { FactoryGirl.create(:family_deal) }
    let!(:user) { FactoryGirl.create(:user) }

    before(:each) do
      visit root_path
      fill_in 'Email', with: 'adigitalnative@gmail.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
      visit family_deals_path
    end

    it "displays deals in the system" do
      page.should have_content(deal_one.long_title)
    end

    it "has the correct number of deals" do
      FamilyDeal.all.count.should == 2
    end
  end

  describe "#new" do
    let!(:user) { FactoryGirl.create(:user) }
    before(:each) do 
      visit root_path
      fill_in 'Email', with: 'adigitalnative@gmail.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
      visit new_family_deal_path
    end

    it "should have a list of today's deals" do
      page.should have_selector("#family_deals")
    end

  end

end