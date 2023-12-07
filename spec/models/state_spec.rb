# frozen_string_literal: true

# Run with < rspec spec/models/state_spec.rb >

require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'std_fips_code' do
    it 'converts state to fips code' do
      state = described_class.new(name: 'State', fips_code: '0')
      expect(state.std_fips_code).to eq('00')
    end
  end
end
