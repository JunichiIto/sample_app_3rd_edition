require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  specify "should get new" do
    get :new
    expect(response).to have_http_status(:success)
  end
end
