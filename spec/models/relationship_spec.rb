require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  specify "should be valid" do
    expect(@relationship).to be_valid
  end

  specify "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship).to be_invalid
  end

  specify "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship).to be_invalid
  end
end
