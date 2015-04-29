require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  specify "should get home" do
    visit root_path
    expect(page).to have_title "Ruby on Rails Tutorial Sample App"
  end

  specify "should get help" do
    visit help_path
    expect(page).to have_title "Help | Ruby on Rails Tutorial Sample App"
  end

  specify "should get about" do
    visit about_path
    expect(page).to have_title "About | Ruby on Rails Tutorial Sample App"
  end

  specify "should get contact" do
    visit contact_path
    expect(page).to have_title "Contact | Ruby on Rails Tutorial Sample App"
  end
end
