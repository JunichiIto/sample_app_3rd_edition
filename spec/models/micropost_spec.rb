require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:user) { users(:michael) }
  let(:micropost) { user.microposts.build(content: "Lorem ipsum") }

  specify "should be valid" do
    expect(micropost).to be_valid
  end
  
  specify "user id should be present" do
    micropost.user_id = nil
    expect(micropost).to be_invalid
  end

  specify "content should be present" do
    micropost.content = "   "
    expect(micropost).to be_invalid
  end

  specify "content should be at most 140 characters" do
    micropost.content = "a" * 141
    expect(micropost).to be_invalid
  end

  specify "order should be most recent first" do
    most_recent = microposts(:most_recent)
    expect(Micropost.first).to eq most_recent
  end
end
