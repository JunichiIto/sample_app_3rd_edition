require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { users(:michael) }
  let(:other) { users(:archer) }
  
  specify "should redirect create when not logged in" do
    expect { post :create }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy when not logged in" do
    one = relationships(:one)
    expect { delete :destroy, id: one }.to_not change { Relationship.count }
    expect(response).to redirect_to login_url
  end

  context 'when logged in' do
    before do
      log_in_as(user)
    end

    specify "should follow a user with Ajax" do
      expect { xhr :post, :create, followed_id: other.id }.to change { user.following.count }.by(1)
    end

    specify "should unfollow a user with Ajax" do
      user.follow(other)
      relationship = user.active_relationships.find_by(followed_id: other.id)
      expect { xhr :delete, :destroy, id: relationship.id }.to change { user.following.count }.by(-1)
    end
  end
end
