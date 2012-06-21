require 'spec_helper'

describe 'Logging in' do
  context 'when user has no account' do
    before(:each) {
      visit root_path
    }

    it "asks the user to log in" do
      page.should have_content("Sign in")
    end

    it "has an option to sign up" do
      page.should have_content("Sign up")
    end

    describe "creating an account" do
      it "asks for login information" do
        click_link_or_button("Sign up")
        page.should have_selector("#new_user")
      end

      it "does things" do
        pending "testing seems unwise as this is testing that Devise works. Return to later"
      end
    end

  end

end
