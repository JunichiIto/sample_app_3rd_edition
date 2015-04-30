require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  before do
    ActionMailer::Base.deliveries.clear
    @user = create :michael
  end

  specify "password resets" do
    visit new_password_reset_path
    expect(page).to have_selector 'h1', 'Forgot password'
    # Invalid email
    fill_in 'Email', with: ""
    click_button 'Submit'
    expect(page).to have_selector '.alert'
    expect(page).to have_selector 'h1', 'Forgot password'
    # Valid email
    fill_in 'Email', with: @user.email
    click_button 'Submit'
    old_digest = @user.reset_digest
    expect(@user.reload.reset_digest).to_not eq old_digest
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(page).to have_selector '.alert'
    expect(current_url).to eq root_url
    # Password reset form
    mail = ActionMailer::Base.deliveries.last
    reset_token = mail.body.encoded[/(?<=password_resets\/)[^\/]+/]
    # Wrong email
    visit edit_password_reset_path(reset_token, email: "")
    expect(current_url).to eq root_url
    # Inactive user
    @user.toggle!(:activated)
    visit edit_password_reset_path(reset_token, email: @user.email)
    expect(current_url).to eq root_url
    @user.toggle!(:activated)
    # Right email, wrong token
    visit edit_password_reset_path('wrong token', email: @user.email)
    expect(current_url).to eq root_url
    # Right email, right token
    visit edit_password_reset_path(reset_token, email: @user.email)
    expect(page).to have_selector 'h1', 'Reset password'
    hidden_email = find 'input[name=email][type=hidden]'
    expect(hidden_email.value).to eq @user.email
    # Invalid password & confirmation
    fill_in 'Password', with: "foobaz"
    fill_in 'Confirmation', with: "barquux"
    click_button 'Update password'
    expect(page).to have_selector 'div#error_explanation'
    # Blank password
    fill_in 'Password', with: "  "
    fill_in 'Confirmation', with: "foobar"
    click_button 'Update password'
    expect(page).to have_selector '.alert'
    expect(page).to have_selector 'h1', 'Reset password'
    # Valid password & confirmation
    fill_in 'Password', with: "foobaz"
    fill_in 'Confirmation', with: "foobaz"
    click_button 'Update password'
    expect(is_logged_in?).to be_truthy
    expect(page).to have_selector '.alert'
    expect(current_path).to eq user_path(@user)
  end
end
