# Run with < rspec spec/controllers/map_controller_spec.rb >

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  describe '#index' do
    it 'assigns all states to @states and indexes them by FIPS code' do
      states = [instance_double(State, std_fips_code: '01'), instance_double(State, std_fips_code: '02')]
      allow(State).to receive(:all).and_return(states)

      get :index
      expect(assigns(:states)).to eq(states)
      expect(assigns(:states_by_fips_code)).to eq(states.index_by(&:std_fips_code))
    end
  end

  describe '#state' do
    let(:state) { instance_double(State, symbol: 'CA') }
    let(:counties) { [instance_double(County, std_fips_code: '06001', state: state)] }
    let(:counties_by_fips_code) { { '06001' => counties[0] } }

    before do
      allow(State).to receive(:find_by).with(symbol: 'CA').and_return(state)
      allow(state).to receive(:counties).and_return(counties)
    end

    context 'when state is found' do
      before { get :state, params: { state_symbol: 'CA' } }

      it 'assigns the requested state to @state' do
        expect(assigns(:state)).to eq(state)
      end

      it 'assigns county details to @county_details' do
        allow(counties).to receive(:index_by).and_return(counties_by_fips_code)
        expect(assigns(:county_details)).to eq(counties_by_fips_code)
      end
    end

    context 'when state is not found' do
      it 'redirects to root_path with a flash message' do
        allow(State).to receive(:find_by).and_return(nil)

        get :state, params: { state_symbol: 'XYZ' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("State 'XYZ' not found.")
      end
    end
  end

  describe '#county' do
    let(:state) { instance_double(State, symbol: 'CA', id: 1) }
    let(:county) { instance_double(County, std_fips_code: '06001', state: state) }

    before do
      allow(State).to receive(:find_by).with(symbol: 'CA').and_return(state)
      allow(County).to receive(:find_by).and_return(county)
      allow(state).to receive(:counties).and_return([county])
      allow(county).to receive(:std_fips_code).and_return('06001')
    end

    context 'when state and county are found' do
      it 'assigns the requested state, county, and county details to @state, @county, and @county_details' do
        get :county, params: { state_symbol: 'CA', std_fips_code: '06001' }
        expect(assigns(:state)).to eq(state)
        expect(assigns(:county)).to eq(county)
        expect(assigns(:county_details)).to eq(state.counties.index_by(&:std_fips_code))
      end
    end

    # context 'when county is not found' do
  end
end
