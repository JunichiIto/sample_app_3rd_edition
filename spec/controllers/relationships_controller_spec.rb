require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  specify "should redirect create when not logged in" do
    expect { post :create }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy when not logged in" do
    one = FactoryGirl.create :one
    expect { delete :destroy, id: one }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end
end
