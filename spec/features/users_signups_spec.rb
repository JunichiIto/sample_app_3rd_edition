require 'rails_helper'

RSpec.feature "UsersSignup", type: :feature do
  before do
    ActionMailer::Base.deliveries.clear
  end

  specify "invalid signup information" do
    visit signup_path
    fill_in 'Name', with: ""
    fill_in 'Email', with: "user@invalid"
    fill_in 'Password', with: "foo"
    fill_in 'Confirmation', with: "bar"
    expect { click_button 'Create my account' }.to_not change { User.count }
    expect(page).to have_selector 'h1', text: 'Sign up'
  end

  specify "valid signup information" do
    visit signup_path
    fill_in 'Name', with: "Example User"
    fill_in 'Email', with: "user@example.com"
    fill_in 'Password', with: "password"
    fill_in 'Confirmation', with: "password"
    expect { click_button 'Create my account' }.to change { User.count }.by(1)
    expect(ActionMailer::Base.deliveries.size).to eq 1
    user = User.last
    expect(user.activated?).to be_falsey
    # Try to log in before activation.
    log_in_as(user)
    expect(is_logged_in?).to be_falsey
    # Invalid activation token
    visit edit_account_activation_path("invalid token")
    expect(is_logged_in?).to be_falsey

    mail = ActionMailer::Base.deliveries.last
    activation_token = mail.body.encoded[/(?<=account_activations\/)[^\/]+/]

    visit edit_account_activation_path(activation_token, email: 'wrong')
    expect(is_logged_in?).to be_falsey
    visit edit_account_activation_path(activation_token, email: user.email)
    expect(user.reload.activated?).to be_truthy
    expect(page).to have_selector 'h1', text: user.name
    expect(is_logged_in?).to be_truthy
  end
end
