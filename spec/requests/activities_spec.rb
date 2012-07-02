require 'spec_helper'

describe 'activities' do

  context "when there are activities" do
    let!(:activity_one) { FactoryGirl.create(:activity, name: "Activity One") }
    let!(:activity_two) { FactoryGirl.create(:activity, name: "Activity Two") }

    before(:each) do
      visit activities_path
    end

    it "has a list of the activites" do
      page.should have_content(activity_one.name)
      page.should have_content(activity_two.name)
    end
  end
end