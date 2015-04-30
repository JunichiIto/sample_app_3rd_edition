require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  before do 
    @micropost = FactoryGirl.create :orange
  end

  specify "should redirect create when not logged in" do
    expect { post :create, micropost: { content: "Lorem ipsum" } }.to_not change { Micropost.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy when not logged in" do
    expect { delete :destroy, id: @micropost }.to_not change { Micropost.count }
    expect(response).to redirect_to login_url
  end

  specify "should redirect destroy for wrong micropost" do
    user = FactoryGirl.create :michael
    log_in_as(user)
    ants = FactoryGirl.create :ants
    expect { delete :destroy, id: ants }.to_not change { Micropost.count }
  end
end
