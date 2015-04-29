require 'rails_helper'

RSpec.feature "Following", type: :feature do
  before do
    @user = FactoryGirl.create :michael
    @other = FactoryGirl.create :archer
    log_in_as(@user)

    lana = FactoryGirl.create :lana
    mallory = FactoryGirl.create :mallory
    @user.follow(lana)
    @user.follow(mallory)
    lana.follow(@user)
    @other.follow(@user)
  end

  specify "following page" do
    visit following_user_path(@user)
    expect(@user.following.empty?).to be_falsey
    expect(page).to have_content @user.following.count
    @user.following.each do |user|
      expect(page).to have_link nil, user_path(user)
    end
  end

  specify "followers page" do
    visit followers_user_path(@user)
    expect(@user.followers.empty?).to be_falsey
    expect(page).to have_content @user.followers.count
    @user.followers.each do |user|
      expect(page).to have_link nil, user_path(user)
    end
  end

  specify "should follow a user the standard way" do
    visit user_path(@other)
    expect { click_button 'Follow' }.to change { @user.following.count }.by(1)
  end

  # Convert later
  xspecify "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end

  specify "should unfollow a user the standard way" do
    @user.follow(@other)
    visit user_path(@other)
    expect { click_button 'Unfollow' }.to change { @user.following.count }.by(-1)
  end

  # Convert later
  xspecify "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
