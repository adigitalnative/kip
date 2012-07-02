require 'spec_helper'

describe 'activities' do

  context "when there are activities" do
    let!(:activity_one) { FactoryGirl.create(:activity, name: "Activity One") }
    let!(:activity_two) { FactoryGirl.create(:activity, name: "Activity Two") }
    let!(:user) { FactoryGirl.create(:user) }

    before(:each) do
      visit root_path
      fill_in 'Email', with: 'adigitalnative@gmail.com'
      fill_in 'Password', with: 'hungry'
      click_link_or_button("Sign in")
      visit activities_path
    end

    it "has a list of the activities" do
      page.should have_content(activity_one.name)
      page.should have_content(activity_two.name)
    end
  end
end