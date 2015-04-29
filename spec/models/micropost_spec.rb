require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryGirl.create :michael
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  specify "should be valid" do
    expect(@micropost.valid?).to be_truthy
  end
  
  specify "user id should be present" do
    @micropost.user_id = nil
    expect(@micropost.valid?).to be_falsey
  end

  specify "content should be present" do
    @micropost.content = "   "
    expect(@micropost.valid?).to be_falsey
  end

  specify "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    expect(@micropost.valid?).to be_falsey
  end

  # TODO Convert later
  # test "order should be most recent first" do
  #   assert_equal Micropost.first, microposts(:most_recent)
  # end
end
