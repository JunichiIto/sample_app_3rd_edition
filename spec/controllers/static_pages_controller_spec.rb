require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  specify "should get home" do
    get :home
    expect(response).to have_http_status :success
    # Title is tested in feature spec
  end

  specify "should get help" do
    get :help
    expect(response).to have_http_status :success
  end

  specify "should get about" do
    get :about
    expect(response).to have_http_status :success
  end

  specify "should get contact" do
    get :contact
    expect(response).to have_http_status :success
  end
end
