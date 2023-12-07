# frozen_string_literal: true

# Run with < rspec spec/models/representative_spec.rb >

require 'rails_helper'

FAKE_CLASS = 'fake_class'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    before do
      rep_info = instance_double(FAKE_CLASS,
                                 officials: [
                                   instance_double(FAKE_CLASS,
                                                   name:    'rep1',
                                                   title:   "Mayor's Office",
                                                   party:   'Republican',
                                                   address: [instance_double(FAKE_CLASS,
                                                                             line1: '123 Main St', city: 'Cityville',
                                                                             zip: '54321', state: 'CA')]),
                                   instance_double(FAKE_CLASS,
                                                   name:    'rep2',
                                                   title:   'Council Office',
                                                   party:   'Democrat',
                                                   address: [instance_double(FAKE_CLASS,
                                                                             line1: '456 Oak St', city: 'Townsville',
                                                                             zip: '98765', state: 'NY')])
                                 ],
                                 offices:   [
                                   instance_double(FAKE_CLASS, official_indices: [0], name: "Mayor's Office",
                                     division_id: 'ocdid123'),
                                   instance_double(FAKE_CLASS, official_indices: [1], name: 'Council Office',
                                     division_id: 'ocdid456')
                                 ])
      allow(rep_info.officials[0]).to receive(:photo_url).and_return('http://example.com/photo1.jpg')
      allow(rep_info.officials[1]).to receive(:photo_url).and_return('http://example.com/photo2.jpg')
      allow(rep_info).to receive(:offices).and_return(rep_info.offices)
      @representatives = described_class.civic_api_to_representative_params(rep_info)
    end

    it 'returns the representatives' do
      expect(@representatives).to be_an(Array)
      expect(@representatives.length).to eq(2)
    end

    it 'checks rep1 part 1/2' do
      expect(@representatives[0].name).to eq('rep1')
      expect(@representatives[0].title).to eq("Mayor's Office")
      expect(@representatives[0].street).to eq('123 Main St')
      expect(@representatives[0].city).to eq('Cityville')
    end

    it 'checks rep1 part 2/2' do
      expect(@representatives[0].zip).to eq('54321')
      expect(@representatives[0].state).to eq('CA')
      expect(@representatives[0].party).to eq('Republican')
    end

    it 'checks rep2 part 1/2' do
      expect(@representatives[1].name).to eq('rep2')
      expect(@representatives[1].title).to eq('Council Office')
      expect(@representatives[1].street).to eq('456 Oak St')
      expect(@representatives[1].city).to eq('Townsville')
    end

    it 'checks rep2 part 2/2' do
      expect(@representatives[1].zip).to eq('98765')
      expect(@representatives[1].state).to eq('NY')
      expect(@representatives[1].party).to eq('Democrat')
    end
  end

  describe '.asign_address' do
    before do
      rep_info = instance_double(FAKE_CLASS,
                                 address:   [instance_double(FAKE_CLASS, line1: '123 Main St',
                                 city: 'Cityville', zip: '54321', state: 'CA')],
                                 name:      'rep',
                                 party:     'Republican',
                                 photo_url: 'http://example.com/photo.jpg')
      allow(rep_info).to receive(:offices).and_return([
                                                        instance_double(FAKE_CLASS, official_indices: [0],
      name: "Mayor's Office", division_id: 'ocdid123')
                                                      ])

      @representative = described_class.asign_address(rep_info, rep_info, 0)
    end

    it 'creates or updates a representative with valid input part 1/3' do
      expect(@representative).to be_a(described_class)
      expect(@representative.name).to eq('rep')
      expect(@representative.title).to eq("Mayor's Office")
    end

    it 'creates or updates a representative with valid input part 2/3' do
      expect(@representative.street).to eq('123 Main St')
      expect(@representative.city).to eq('Cityville')
      expect(@representative.zip).to eq('54321')
    end

    it 'creates or updates a representative with valid input part 3/3' do
      expect(@representative.state).to eq('CA')
      expect(@representative.party).to eq('Republican')
      expect(@representative.photo).to eq('http://example.com/photo.jpg')
    end
  end

  describe '.get_office' do
    before do
      @rep_info = instance_double(FAKE_CLASS,
                                  offices: [
                                    instance_double(FAKE_CLASS, official_indices: [0], name: "Mayor's Office",
 division_id: 'ocdid123'),
                                    instance_double(FAKE_CLASS, official_indices: [1], name: 'Council Office',
 division_id: 'ocdid456')
                                  ])
    end

    it 'returns title and ocdid with valid input' do
      title, ocdid = described_class.get_office(@rep_info, 0)

      expect(title).to eq("Mayor's Office")
      expect(ocdid).to eq('ocdid123')
    end
  end
end
