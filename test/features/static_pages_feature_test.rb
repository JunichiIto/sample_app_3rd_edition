require "test_helper"

class StaticPagesFeatureTest < Capybara::Rails::TestCase
  test "should get home" do
    visit root_path
    assert_title "Ruby on Rails Tutorial Sample App"
  end
end
