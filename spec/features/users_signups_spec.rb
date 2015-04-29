require 'rails_helper'

RSpec.feature "UsersSignup", type: :feature do
  before do
    ActionMailer::Base.deliveries.clear
  end

  specify "invalid signup information" do
    visit signup_path
    fill_in 'Name', with: ""
    fill_in 'Email', with: "user@invalid"
    fill_in 'Password', with: "foo"
    fill_in 'Confirmation', with: "bar"
    expect { click_button 'Create my account' }.to_not change { User.count }
    expect(page).to have_selector 'h1', text: 'Sign up'
  end
end
