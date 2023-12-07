# frozen_string_literal: true

# Run with < rspec spec/controllers/search_controller_spec.rb >

require 'rails_helper'
require 'google/apis/civicinfo_v2'

FAKE_CLASS = 'fake_class'

RSpec.describe SearchController, type: :controller do
  describe '#search' do
    let(:address) { '123 Main St' }
    let(:representatives) { [instance_double(Representative)] }
    let(:office_double) { instance_double(FAKE_CLASS, name: 'Some Office', division_id: 'ocdid:some_id') }
    let(:rep_info_double) do
      instance_double(FAKE_CLASS, representatives: representatives, officials: [instance_double(FAKE_CLASS)],
                                       offices: [office_double])
    end
    let(:civic_info_service_double) { instance_double(Google::Apis::CivicinfoV2::CivicInfoService) }

    before do
      allow(Google::Apis::CivicinfoV2::CivicInfoService)
        .to receive(:new).and_return(civic_info_service_double)

      allow(civic_info_service_double)
        .to receive(:key=)
      allow(civic_info_service_double)
        .to receive(:representative_info_by_address).with(address: address).and_return(rep_info_double)
    end

    it 'assigns @representatives with data from the Google API' do
      allow(Representative).to receive(:civic_api_to_representative_params)
        .with(rep_info_double).and_return(representatives)

      get :search, params: { address: address }
      expect(assigns(:representatives)).to eq(representatives)
    end
  end
end
