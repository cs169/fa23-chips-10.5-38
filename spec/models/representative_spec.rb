# frozen_string_literal: true

# Run with < rspec spec/models/representative_spec.rb >

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    it 'returns an array of representatives with valid input' do
      # Simulating civic API response
      rep_info = instance_double(RepInfo,
                                 officials: [
                                   instance_double(Official, {
                                                     name:    'name1',
                                                     title:   "Mayor's Office",
                                                     party:   'Republican',
                                                     address: [instance_double(Address, {
                                                                                 line1: '123 Main St',
                                                                                 city:  'Cityville',
                                                                                 zip:   '54321',
                                                                                 state: 'CA'
                                                                               })]
                                                   })
                                 ],
                                 offices:   [
                                   instance_double(Office, {
                                                     official_indices: [0],
                                                     name:             "Mayor's Office",
                                                     division_id:      'ocdid123'
                                                   })
                                 ])
      allow(rep_info.officials[0]).to receive(:photo_url).and_return('http://example.com/photo1.jpg')

      # Mock the 'offices' method to return the expected array
      allow(rep_info).to receive(:offices).and_return(rep_info.offices)

      representatives = described_class.civic_api_to_representative_params(rep_info)

      expect(representatives).to be_an(Array)
      expect(representatives.length).to eq(1)

      expect(representatives[0].name).to eq('name1')
      expect(representatives[0].title).to eq("Mayor's Office")
      expect(representatives[0].street).to eq('123 Main St')
      expect(representatives[0].city).to eq('Cityville')
      expect(representatives[0].zip).to eq('54321')
      expect(representatives[0].state).to eq('CA')
      expect(representatives[0].party).to eq('Republican')
    end
  end

  describe '.asign_address' do
    it 'creates or updates a representative with valid input' do
      # Simulating civic API response
      rep_info = instance_double(RepInfo, {
                                   address:   [instance_double(Address, {
                                                                 line1: '123 Main St',
                                                                 city:  'Cityville',
                                                                 zip:   '54321',
                                                                 state: 'CA'
                                                               })],
                                   name:      'name1',
                                   party:     'Republican',
                                   photo_url: 'http://example.com/photo.jpg'
                                 })
      allow(rep_info).to receive(:offices).and_return([
                                                        instance_double(Office, {
                                                                          official_indices: [0],
                                                                          name:             "Mayor's Office",
                                                                          division_id:      'ocdid123'
                                                                        })
                                                      ])

      representative = described_class.asign_address(rep_info, rep_info, 0)

      expect(representative).to be_a(described_class)
      expect(representative.name).to eq('name1')
      expect(representative.title).to eq("Mayor's Office")
      expect(representative.street).to eq('123 Main St')
      expect(representative.city).to eq('Cityville')
      expect(representative.zip).to eq('54321')
      expect(representative.state).to eq('CA')
      expect(representative.party).to eq('Republican')
      expect(representative.photo).to eq('http://example.com/photo.jpg')
    end
  end

  describe '.get_office' do
    it 'returns title and ocdid with valid input' do
      # Simulating civic API response
      rep_info = instance_double(RepInfo, {
                                   offices: [
                                     instance_double(Office, {
                                                       official_indices: [0],
                                                       name:             "Mayor's Office",
                                                       division_id:      'ocdid123'
                                                     }),
                                     instance_double(Office, {
                                                       official_indices: [1],
                                                       name:             'Council Office',
                                                       division_id:      'ocdid456'
                                                     })
                                   ]
                                 })

      title, ocdid = described_class.get_office(rep_info, 0)

      expect(title).to eq("Mayor's Office")
      expect(ocdid).to eq('ocdid123')
    end
  end
end
