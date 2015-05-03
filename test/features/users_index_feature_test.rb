require "test_helper"

class UsersIndexFeatureTest < Capybara::Rails::TestCase
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    visit users_path
    assert_selector 'h1', text: 'All users'
    assert_selector 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert has_link? user.name, href: user_path(user)
      unless user == @admin
        assert has_link? 'delete', href: user_path(user)
      end
    end
    assert_difference 'User.count', -1 do
      click_link 'delete', href: user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    visit users_path
    assert has_no_link? 'delete'
  end
end
