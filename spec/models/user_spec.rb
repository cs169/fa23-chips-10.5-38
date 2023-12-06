# Run with < rspec spec/models/user_spec.rb >

require 'rails_helper'

RSpec.describe User, type: :model do

  before(:all) do
    @user_id = '0'
  end

  describe 'find_google_user' do
    it 'find user by google' do
      user = User.create!(provider: :google_oauth2, uid: @user_id)
      expect(User.find_google_user(@user_id)).to eq(user)
    end
  end

  describe 'find_github_user' do
    it 'find user by github' do
      user = User.create!(provider: :github, uid: @user_id)
      expect(User.find_github_user(@user_id)).to eq(user)
    end
  end

end 