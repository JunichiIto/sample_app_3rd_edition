require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create :michael }
  let(:other_user) { create :archer }

  specify "should redirect index when not logged in" do
    get :index
    expect(response).to redirect_to login_url
  end

  specify "should get new" do
    get :new
    expect(response).to have_http_status :success
  end

  specify "should redirect edit when not logged in" do
    get :edit, id: user
    expect(flash).to be_present
    expect(response).to redirect_to login_url
  end

  specify "should redirect update when not logged in" do
    patch :update, id: user, user: { name: user.name, email: user.email }
    expect(flash).to be_present
    expect(response).to redirect_to login_url
  end

  specify "should redirect edit when logged in as wrong user" do
    log_in_as(other_user)
    get :edit, id: user
    expect(flash).to be_empty
    expect(response).to redirect_to root_url
  end

  specify "should redirect update when logged in as wrong user" do
    log_in_as(other_user)
    patch :update, id: user, user: { name: user.name, email: user.email }
    expect(flash).to be_empty
    expect(response).to redirect_to root_url
  end

  specify "should redirect destroy when not logged in" do
    expect { delete :destroy, id: user }.to_not change { User.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy when logged in as a non-admin" do
    log_in_as(other_user)
    expect { delete :destroy, id: user }.to_not change { User.count }
    expect(response).to redirect_to root_url
  end

  specify "should redirect following when not logged in" do
    get :following, id: user
    expect(response).to redirect_to login_url
  end

  specify "should redirect followers when not logged in" do
    get :followers, id: user
    expect(response).to redirect_to login_url
  end
end
