require 'rails_helper'

RSpec.feature "UsersLogin", type: :feature do
  given(:user) { users(:michael) }

  scenario "login with invalid information" do
    visit login_path
    expect(page).to have_selector 'h1', text: 'Log in'
    fill_in 'Email', with: ""
    fill_in 'Password', with: ""
    click_button 'Log in'
    expect(page).to have_selector 'h1', text: 'Log in'
    expect(page).to have_flash_message
    visit root_path
    expect(page).to have_no_flash_message
  end
  
  scenario "login with valid information followed by logout" do
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(is_logged_in?).to be_truthy
    expect(current_path).to eq user_path(user)
    expect(page).to have_selector 'h1', text: user.name
    expect(page).to have_no_link nil, href: login_path
    expect(page).to have_link nil, href: logout_path
    expect(page).to have_link nil, href: user_path(user)
    click_link 'Log out'
    expect(is_logged_in?).to be_falsey
    expect(current_path).to eq root_path
    # Simulate a user clicking logout in a second window.
    # => Tests in sessions_controller_spec
    expect(page).to have_link nil, href: login_path
    expect(page).to have_no_link nil, href: logout_path
    expect(page).to have_no_link nil, href: user_path(user)
  end

  # NOTE login with/without remembering tests are in sessions_controller_spec
end
