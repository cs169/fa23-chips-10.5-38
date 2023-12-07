# Run with < rspec spec/controllers/map_controller_spec.rb >

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  describe '#index' do
    it 'assigns all states to @states and indexes them by FIPS code' do
      states = [double('State', std_fips_code: '01'), double('State', std_fips_code: '02')]
      allow(State).to receive(:all).and_return(states)
      
      get :index
      expect(assigns(:states)).to eq(states)
      expect(assigns(:states_by_fips_code)).to eq(states.index_by(&:std_fips_code))
    end
  end

  describe '#state' do
    context 'when state is found' do
      it 'assigns the requested state and county details to @state and @county_details' do
        state = instance_double('State', symbol: 'CA')
        counties = [instance_double('County', std_fips_code: '06001', state: state)]

        allow(State).to receive(:find_by).and_return(state)
        allow(state).to receive(:counties).and_return(counties)
        allow(counties).to receive(:index_by).and_return({ '06001' => counties[0] })

        get :state, params: { state_symbol: 'CA' }
        expect(assigns(:state)).to eq(state)
        expect(assigns(:county_details)).to eq(counties.index_by(&:std_fips_code))
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
    context 'when state and county are found' do
      it 'assigns the requested state, county, and county details to @state, @county, and @county_details' do
        state = instance_double('State', symbol: 'CA', id: 1)
        county = instance_double('County', std_fips_code: '06001', state: state)

        allow(State).to receive(:find_by).and_return(state)
        allow(County).to receive(:find_by).and_return(county)
        allow(state).to receive(:counties).and_return([county])
        allow(county).to receive(:std_fips_code).and_return('06001')

        get :county, params: { state_symbol: 'CA', std_fips_code: '06001' }
        expect(assigns(:state)).to eq(state)
        expect(assigns(:county)).to eq(county)
        expect(assigns(:county_details)).to eq(state.counties.index_by(&:std_fips_code))
      end
    end

    # context 'when county is not found' do
  end
end