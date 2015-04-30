require 'rails_helper'

RSpec.feature "Following", type: :feature do
  before do
    @user = FactoryGirl.create :michael
    @other = FactoryGirl.create :archer
    log_in_as(@user)

    FactoryGirl.create :one
    FactoryGirl.create :two
    FactoryGirl.create :three
    FactoryGirl.create :four
  end

  specify "following page" do
    visit following_user_path(@user)
    expect(@user.following.empty?).to be_falsey
    expect(page).to have_content @user.following.count
    @user.following.each do |user|
      expect(page).to have_link nil, href: user_path(user)
    end
  end

  specify "followers page" do
    visit followers_user_path(@user)
    expect(@user.followers.empty?).to be_falsey
    expect(page).to have_content @user.followers.count
    @user.followers.each do |user|
      expect(page).to have_link nil, href: user_path(user)
    end
  end

  specify "should follow a user the standard way" do
    visit user_path(@other)
    expect { click_button 'Follow' }.to change { @user.following.count }.by(1)
  end

  # NOTE "should follow a user with Ajax" is tested in relationships_controller_spec

  specify "should unfollow a user the standard way" do
    @user.follow(@other)
    visit user_path(@other)
    expect { click_button 'Unfollow' }.to change { @user.following.count }.by(-1)
  end

  # NOTE "should unfollow a user with Ajax" is tested in relationships_controller_spec
end
