require "test_helper"

class SiteLayoutFeatureTest < Capybara::Rails::TestCase
  test "layout links" do
    visit root_path
    assert_selector 'h1', text: 'Welcome to the Sample App'
    assert has_link? nil, href: root_path, count: 2
    assert has_link? nil, href: help_path
    assert has_link? nil, href: about_path
    assert has_link? nil, href: contact_path
  end
end
