require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  specify "should redirect create when not logged in" do
    expect { post :create, micropost: { content: "Lorem ipsum" } }.to_not change { Micropost.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy when not logged in" do
    micropost = create :orange
    expect { delete :destroy, id: micropost }.to_not change { Micropost.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy for wrong micropost" do
    user = create :michael
    log_in_as(user)
    ants = create :ants
    expect { delete :destroy, id: ants }.to_not change { Micropost.count }
  end
end
