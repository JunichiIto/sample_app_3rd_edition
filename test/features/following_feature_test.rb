require "test_helper"

class FollowingFeatureTest < Capybara::Rails::TestCase
  def setup
    @user  = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    visit following_user_path(@user)
    assert_not @user.following.empty?
    assert_text @user.following.count
    @user.following.each do |user|
      assert has_link? nil, href: user_path(user)
    end
  end

  test "followers page" do
    visit followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_text @user.followers.count
    @user.followers.each do |user|
      assert has_link? nil, href: user_path(user)
    end
  end

  test "should follow a user the standard way" do
    visit user_path(@other)
    assert_difference '@user.following.count', 1 do
      click_button 'Follow'
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    visit user_path(@other)
    assert_difference '@user.following.count', -1 do
      click_button 'Unfollow'
    end
  end
end
