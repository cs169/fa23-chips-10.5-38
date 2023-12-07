# frozen_string_literal: true

# Run with < rspec spec/models/county_spec.rb >

require 'rails_helper'

RSpec.describe County, type: :model do
  describe 'std_fips_code' do
    it 'converts country to fips code' do
      county = described_class.new(name: 'Country', fips_code: 0)
      expect(county.std_fips_code).to eq('000')
    end
  end
end
