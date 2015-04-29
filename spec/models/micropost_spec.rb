require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryGirl.create :michael
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  specify "should be valid" do
    expect(@micropost.valid?).to be_truthy
  end
end
