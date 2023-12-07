# frozen_string_literal: true

# Run with < rspec spec/models/representative_spec.rb >

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    # rubocop:disable RSpec/VerifiedDoubles
    let(:official1) do
      double('official1', name: 'name1', title: "Mayor's Office", party: 'Republican',
     address: [double('address1', line1: '123 Main St', city: 'Cityville', zip: '54321', state: 'CA')])
    end
    let(:official2) do
      double('official2', name: 'name2', title: 'Council Office', party: 'Democrat',
     address: [double('address2', line1: '456 Oak St', city: 'Townsville', zip: '98765', state: 'NY')])
    end
    let(:office1) { double('office1', official_indices: [0], name: "Mayor's Office", division_id: 'ocdid123') }
    let(:office2) { double('office2', official_indices: [1], name: 'Council Office', division_id: 'ocdid456') }
    let(:rep_info) { double('rep_info', officials: [official1, official2], offices: [office1, office2]) }
    # rubocop:enable RSpec/VerifiedDoubles

    before do
      allow(official1).to receive(:photo_url).and_return('http://example.com/photo1.jpg')
      allow(official2).to receive(:photo_url).and_return('http://example.com/photo2.jpg')
      allow(rep_info).to receive(:offices).and_return([office1, office2])
    end

    it 'returns an array of representatives' do
      representatives = described_class.civic_api_to_representative_params(rep_info)
      expect(representatives).to be_an(Array)
      expect(representatives.length).to eq(2)
    end

    # had to split the following into multiple it/do statements for style check:
    it 'has correct info for first rep' do
      representatives = described_class.civic_api_to_representative_params(rep_info)
      expect(representatives[0].name).to eq('name1')
      expect(representatives[0].title).to eq("Mayor's Office")
      expect(representatives[0].street).to eq('123 Main St')
    end

    it 'has correct info for first rep (2)' do
      representatives = described_class.civic_api_to_representative_params(rep_info)
      expect(representatives[0].city).to eq('Cityville')
      expect(representatives[0].zip).to eq('54321')
      expect(representatives[0].state).to eq('CA')
      expect(representatives[0].party).to eq('Republican')
    end

    it 'has correct info for second rep' do
      representatives = described_class.civic_api_to_representative_params(rep_info)
      expect(representatives[1].name).to eq('name2')
      expect(representatives[1].title).to eq('Council Office')
      expect(representatives[1].street).to eq('456 Oak St')
    end

    it 'has correct info for second rep (2)' do
      representatives = described_class.civic_api_to_representative_params(rep_info)
      expect(representatives[1].city).to eq('Townsville')
      expect(representatives[1].zip).to eq('98765')
      expect(representatives[1].state).to eq('NY')
      expect(representatives[1].party).to eq('Democrat')
    end
  end

  describe '.asign_address' do
    context 'with valid input' do
      # rubocop:disable RSpec/VerifiedDoubles
      let(:rep_info) do
        double('rep_info',
               address: [double('address', line1: '123 Main St', city: 'Cityville', zip: '54321', state: 'CA')],
               name: 'name1', party: 'Republican', photo_url: 'http://example.com/photo.jpg')
      end
      let(:office) { double('office1', official_indices: [0], name: "Mayor's Office", division_id: 'ocdid123') }
      # rubocop:enable RSpec/VerifiedDoubles

      before do
        allow(rep_info).to receive(:offices).and_return([office])
      end

      it 'creates a representative (1)' do
        representative = described_class.asign_address(rep_info, rep_info, 0)
        expect(representative).to be_a(described_class)
        expect(representative.name).to eq('name1')
        expect(representative.title).to eq("Mayor's Office")
        expect(representative.street).to eq('123 Main St')
      end

      it 'creates a representative (2)' do
        representative = described_class.asign_address(rep_info, rep_info, 0)
        expect(representative.city).to eq('Cityville')
        expect(representative.zip).to eq('54321')
        expect(representative.state).to eq('CA')
        expect(representative.party).to eq('Republican')
      end

      it 'creates a representative (3)' do
        representative = described_class.asign_address(rep_info, rep_info, 0)
        expect(representative.photo).to eq('http://example.com/photo.jpg')
      end
    end
  end

  describe '.get_office' do
    context 'with valid input' do
      # rubocop:disable RSpec/VerifiedDoubles
      let(:office1) { double('office1', official_indices: [0], name: "Mayor's Office", division_id: 'ocdid123') }
      let(:office2) { double('office2', official_indices: [1], name: 'Council Office', division_id: 'ocdid456') }
      let(:rep_info) { double('rep_info', offices: [office1, office2]) }
      # rubocop:enable RSpec/VerifiedDoubles

      it 'returns title and ocdid' do
        title, ocdid = described_class.get_office(rep_info, 0)
        expect(title).to eq("Mayor's Office")
        expect(ocdid).to eq('ocdid123')
      end
    end
  end
end
