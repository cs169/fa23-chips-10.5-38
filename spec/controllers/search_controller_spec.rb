# Run with < rspec spec/controllers/search_controller_spec.rb >

# spec/controllers/search_controller_spec.rb

require 'rails_helper'
require 'google/apis/civicinfo_v2'

RSpec.describe SearchController, type: :controller do
  describe '#search' do
    let(:address) { '123 Main St' }
    let(:representatives) { [instance_double(Representative)] }
    let(:office_double) { double('office', name: 'Some Office', division_id: 'ocdid:some_id') }
    let(:rep_info_double) { double('result', representatives: representatives, officials: [double('official')], offices: [office_double]) }

    before do
      allow_any_instance_of(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:representative_info_by_address).and_return(rep_info_double)
    end

    it 'assigns @representatives with data from the Google API' do
      expect(Representative).to receive(:civic_api_to_representative_params).with(rep_info_double).and_return(representatives)

      get :search, params: { address: address }
      expect(assigns(:representatives)).to eq(representatives)
    end
  end
end