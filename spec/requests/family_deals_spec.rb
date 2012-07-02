require 'spec_helper'

describe "FamilyDeals" do

  describe "#index" do
    let!(:deal_one) { FactoryGirl.create(:family_deal) }
    let!(:deal_two) { FactoryGirl.create(:family_deal) }
    before(:each) { visit family_deals_path }

    it "displays deals in the syste." do
      page.should have_content(deal_one.long_title)
    end

    it "has the correct number of deals" do
      FamilyDeal.all.count.should == 2
    end
  end

  describe "#new" do
    before(:each) { visit new_family_deal_path }

    it "should have a list of today's deals" do
      page.should have_selector("#family_deals")
    end

  end

end