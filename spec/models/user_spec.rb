# frozen_string_literal: true

# Run with < rspec spec/models/user_spec.rb >

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'find_google_user' do
    it 'find user by google' do
      user = described_class.create!(provider: :google_oauth2, uid: '0')
      expect(described_class.find_google_user('0')).to eq(user)
    end
  end

  describe 'find_github_user' do
    it 'find user by github' do
      user = described_class.create!(provider: :github, uid: '0')
      expect(described_class.find_github_user('0')).to eq(user)
    end
  end
end
