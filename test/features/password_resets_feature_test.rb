require "test_helper"

class PasswordResetsFeatureTest < Capybara::Rails::TestCase
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    visit new_password_reset_path
    assert_selector 'h1', 'Forgot password'
    # Invalid email
    fill_in 'Email', with: ""
    click_button 'Submit'
    assert has_flash_message?
    assert_selector 'h1', 'Forgot password'
    # Valid email
    fill_in 'Email', with: @user.email
    click_button 'Submit'
    old_digest = @user.reset_digest
    assert_not_equal old_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert has_flash_message?
    assert_equal root_url, current_url
    # Password reset form
    mail = ActionMailer::Base.deliveries.last
    reset_token = mail.body.encoded[/(?<=password_resets\/)[^\/]+/]
    # Wrong email
    visit edit_password_reset_path(reset_token, email: "")
    assert_equal root_url, current_url
    # Inactive user
    @user.toggle!(:activated)
    visit edit_password_reset_path(reset_token, email: @user.email)
    assert_equal root_url, current_url
    @user.toggle!(:activated)
    # Right email, wrong token
    visit edit_password_reset_path('wrong token', email: @user.email)
    assert_equal root_url, current_url
    # Right email, right token
    visit edit_password_reset_path(reset_token, email: @user.email)
    assert_selector 'h1', 'Reset password'
    hidden_email = find 'input[name=email][type=hidden]'
    assert_equal @user.email, hidden_email.value
    # Invalid password & confirmation
    fill_in 'Password', with: "foobaz"
    fill_in 'Confirmation', with: "barquux"
    click_button 'Update password'
    assert_selector 'div#error_explanation'
    # Blank password
    fill_in 'Password', with: "  "
    fill_in 'Confirmation', with: "foobar"
    click_button 'Update password'
    assert has_flash_message?
    assert_selector 'h1', 'Reset password'
    # Valid password & confirmation
    fill_in 'Password', with: "foobaz"
    fill_in 'Confirmation', with: "foobaz"
    click_button 'Update password'
    assert is_logged_in?
    assert has_flash_message?
    assert_equal user_path(@user), current_path
  end
end
