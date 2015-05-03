require "test_helper"

class UsersProfileFeatureTest < Capybara::Rails::TestCase
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    visit user_path(@user)
    assert_selector 'h1', text: @user.name
    assert_title full_title(@user.name)
    assert_selector 'h1>img.gravatar'
    assert_text @user.microposts.count
    assert_selector 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_text micropost.content
    end
  end
end
