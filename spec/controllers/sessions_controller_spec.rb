require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create :michael }

  specify "should get new" do
    get :new
    expect(response).to have_http_status :success
  end

  specify "login with valid information followed by logout" do
    post :create, session: { email: user.email, password: 'password' }
    expect(is_logged_in?).to be_truthy

    delete :destroy
    expect(is_logged_in?).to be_falsey

    # Simulate a user clicking logout in a second window.
    delete :destroy
    expect(response).to redirect_to root_path
  end

  specify "login with remembering" do
    post :create, session: { email: user.email, password: 'password', remember_me: '1' }
    expect(cookies['remember_token']).to_not be_nil
  end

  specify "login without remembering" do
    post :create, session: { email: user.email, password: 'password', remember_me: '0' }
    expect(cookies['remember_token']).to be_nil
  end
end
