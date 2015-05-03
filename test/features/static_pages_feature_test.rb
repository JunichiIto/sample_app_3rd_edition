require "test_helper"

class StaticPagesFeatureTest < Capybara::Rails::TestCase
  test "should get home" do
    visit root_path
    assert_title "Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    visit help_path
    assert_title "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
    visit about_path
    assert_title "About | Ruby on Rails Tutorial Sample App"
  end

  test "should get contact" do
    visit contact_path
    assert_title "Contact | Ruby on Rails Tutorial Sample App"
  end
end
