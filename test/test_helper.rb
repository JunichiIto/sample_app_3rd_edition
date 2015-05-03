ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
require "minitest/rails/capybara"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    if feature_test?
      has_link? 'Log out'
    else
      !session[:user_id].nil?
    end
  end
  
  # Logs in a test user.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    elsif feature_test?
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      if remember_me == '1'
        check 'Remember me on this computer'
      end
      click_button 'Log in'
    else
      session[:user_id] = user.id
    end
  end
  
  private
  
    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

    def feature_test?
      self.is_a? Capybara::Rails::TestCase
    end
end
