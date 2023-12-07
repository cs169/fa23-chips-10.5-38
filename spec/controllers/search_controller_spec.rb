# frozen_string_literal: true

# Run with < rspec spec/controllers/search_controller_spec.rb >

# spec/controllers/search_controller_spec.rb

require 'rails_helper'
require 'google/apis/civicinfo_v2'

RSpec.describe SearchController, type: :controller do
  describe '#search' do
    let(:address) { '123 Main St' }
    let(:representatives) { [instance_double(Representative)] }
    let(:service) { instance_double(Google::Apis::CivicinfoV2::CivicInfoService) }
    # rubocop:disable RSpec/VerifiedDoubles
    let(:rep_info_double) { double('RepresentativeInfoResponse', representatives: representatives) }
    # rubocop:enable RSpec/VerifiedDoubles

    before do
      allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(service)
      allow(service).to receive(:key=)
      allow(service).to receive(:representative_info_by_address).and_return(rep_info_double)
      allow(Representative).to receive(:civic_api_to_representative_params)
        .with(rep_info_double)
        .and_return(representatives)
    end

    it 'assigns @representatives with data from the Google API' do
      get :search, params: { address: address }
      expect(assigns(:representatives)).to eq(representatives)
    end
  end
end
