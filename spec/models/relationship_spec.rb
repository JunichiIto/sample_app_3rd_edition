require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  specify "should be valid" do
    expect(@relationship.valid?).to be_truthy
  end

  specify "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship.valid?).to be_falsey
  end

  specify "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship.valid?).to be_falsey
  end
end
