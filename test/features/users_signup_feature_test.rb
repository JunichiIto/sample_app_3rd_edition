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

  test "valid signup information" do
    visit signup_path
    fill_in 'Name', with: "Example User"
    fill_in 'Email', with: "user@example.com"
    fill_in 'Password', with: "password"
    fill_in 'Confirmation', with: "password"
    assert_difference 'User.count', 1 do
      click_button 'Create my account'
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = User.last
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    visit edit_account_activation_path("invalid token")
    assert_not is_logged_in?

    mail = ActionMailer::Base.deliveries.last
    activation_token = mail.body.encoded[/(?<=account_activations\/)[^\/]+/]

    visit edit_account_activation_path(activation_token, email: 'wrong')
    assert_not is_logged_in?
    visit edit_account_activation_path(activation_token, email: user.email)
    assert user.reload.activated?
    assert_selector 'h1', text: user.name
    assert is_logged_in?
  end
end
