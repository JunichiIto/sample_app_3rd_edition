require "test_helper"

class MicropostsInterfaceFeatureTest < Capybara::Rails::TestCase
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    visit root_path
    assert_selector 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      fill_in 'micropost_content', with: ""
      click_button 'Post'
    end
    assert_selector 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room tovisither"
    assert_difference 'Micropost.count', 1 do
      fill_in 'micropost_content', with: content
      click_button 'Post'
    end
    assert_equal root_url, current_url
    assert_text content
    # Delete a post.
    assert has_link? 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      click_link 'delete', href: micropost_path(first_micropost)
    end
    # Visit a different user.
    visit user_path(users(:archer))
    assert has_no_link? 'delete'
  end
end
