require "test_helper"

class UsersSignupFeatureTest < Capybara::Rails::TestCase
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    visit signup_path
    fill_in 'Name', with: ""
    fill_in 'Email', with: "user@invalid"
    fill_in 'Password', with: "foo"
    fill_in 'Confirmation', with: "bar"
    assert_no_difference 'User.count' do
      click_button 'Create my account'
    end
    assert_selector 'h1', text: 'Sign up'
  end
end
