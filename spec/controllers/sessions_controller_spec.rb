require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  specify "should get new" do
    get :new
    expect(response).to have_http_status :success
  end

  specify "login with valid information followed by logout" do
    user = FactoryGirl.create :michael
    post :create, session: { email: user.email, password: 'password' }
    expect(is_logged_in?).to be_truthy

    delete :destroy
    expect(is_logged_in?).to be_falsey

    # Simulate a user clicking logout in a second window.
    delete :destroy
    expect(response).to redirect_to root_path
  end
end
