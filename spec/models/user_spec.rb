require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'Example User', email: 'user@example.com',
      password: 'foobar', password_confirmation: 'foobar')
  end

  specify 'should be valid' do
    expect(@user.valid?).to be_truthy
  end

  specify 'name should be present' do
    @user.name = ' '
  end

  specify 'email should be present' do
    @user.email = ' '
    expect(@user.valid?).to be_falsey
  end

  specify 'name should not be too long' do
    @user.name = 'a' * 51
    expect(@user.valid?).to be_falsey
  end

  specify 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    expect(@user.valid?).to be_falsey
  end

  specify 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_USE-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user.valid?).to be_truthy, "#{valid_address.inspect} should be valid"
    end
  end

  specify 'email validation should reject valid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user.valid?).to be_falsey, "#{invalid_address.inspect} should be invalid"
    end
  end

  specify 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user.valid?).to be_falsey
  end

  specify 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    expect(@user.valid?).to be_falsey
  end

  specify 'authenticated? should return false for a user with nil digest' do
    expect(@user.authenticated?(:remember, '')).to be_falsey
  end

  specify 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')
    expect { @user.destroy }.to change { Micropost.count }.by(-1)
  end
  
  specify 'should follow and unfollow a user' do
    michael = FactoryGirl.create :michael
    archer = FactoryGirl.create :archer
    expect(michael.following?(archer)).to be_falsey
    michael.follow(archer)
    expect(michael.following?(archer)).to be_truthy
    expect(archer.followers.include?(michael)).to be_truthy
    michael.unfollow(archer)
    expect(michael.following?(archer)).to be_falsey
  end
  
  specify 'feed should have the right posts' do
    michael = FactoryGirl.create :michael_with_microposts
    archer = FactoryGirl.create :archer_with_microposts
    lana = FactoryGirl.create :lana_with_microposts

    FactoryGirl.create :one

    expect(michael.microposts.count).to be > 0
    expect(archer.microposts.count).to be > 0
    expect(lana.microposts.count).to be > 0

    lana.microposts.each do |post_following|
      expect(michael.feed.include?(post_following)).to be_truthy
    end
  
    michael.microposts.each do |post_self|
      expect(michael.feed.include?(post_self)).to be_truthy
    end
  
    archer.microposts.each do |post_unfollowed|
      expect(michael.feed.include?(post_unfollowed)).to be_falsey
    end
  end
end
