require "test_helper"

class UsersEditFeatureTest < Capybara::Rails::TestCase
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    visit edit_user_path(@user)
    assert_selector 'h1', text: 'Update your profile'
    fill_in 'Name', with: ""
    fill_in 'Email', with: "user@invalid"
    fill_in 'Password', with: "foo"
    fill_in 'Confirmation', with: "bar"
    click_button 'Save changes'
    assert_selector 'h1', text: 'Update your profile'
  end

  test "successful edit with friendly forwarding" do
    visit edit_user_path(@user)
    log_in_as(@user)
    assert_equal edit_user_path(@user), current_path
    name  = "Foo Bar"
    email = "foo@bar.com"
    fill_in 'Name', with: name
    fill_in 'Email', with: email
    fill_in 'Password', with: ""
    fill_in 'Confirmation', with: ""
    click_button 'Save changes'
    assert has_flash_message?
    assert_equal user_path(@user), current_path
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
