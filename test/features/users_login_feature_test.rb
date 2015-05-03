require "test_helper"

class UsersLoginFeatureTest < Capybara::Rails::TestCase
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    visit login_path
    assert_selector 'h1', text: 'Log in'
    fill_in 'Email', with: ""
    fill_in 'Password', with: ""
    click_button 'Log in'
    assert_selector 'h1', text: 'Log in'
    assert has_flash_message?
    visit root_path
    assert_not has_flash_message?
  end

  test "login with valid information followed by logout" do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    assert is_logged_in?
    assert_equal user_path(@user), current_path
    assert_selector 'h1', text: @user.name
    assert_not has_link? nil, href: login_path
    assert has_link? nil, href: logout_path
    assert has_link? nil, href: user_path(@user)
    click_link 'Log out'
    assert_not is_logged_in?
    assert_equal root_path, current_path
    # Simulate a user clicking logout in a second window.
    # => Tests in sessions_controller_spec
    assert has_link? nil, href: login_path
    assert_not has_link? nil, href: logout_path
    assert_not has_link? nil, href: user_path(@user)
  end
end
