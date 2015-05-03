require "test_helper"

class FollowingFeatureAjaxTest < Capybara::Rails::TestCase
  def setup
    Capybara.current_driver = Capybara.javascript_driver

    @user  = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "should follow a user with Ajax" do
    visit user_path(@other)
    assert_difference '@user.following.count', 1 do
      click_button 'Follow'
      sleep 0.2
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    visit user_path(@other)
    assert_difference '@user.following.count', -1 do
      click_button 'Unfollow'
      sleep 0.2
    end
  end
end
