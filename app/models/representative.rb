# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  #can do characterization tests in the fetures folder, can do cucumber tests file is .feature
  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''
      street = 'N/A'
      city = 'N/A'
      zip = 'N/A'
      state = 'N/A'

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end

      unless official.address.nil?
        street = official.address[0].line1
        city = official.address[0].city
        zip = official.address[0].zip
        state = official.address[0].state 
      end

      photo = ''

      if !official.photo_url.nil?
        photo = official.photo_url
      end

      rep = Representative.find_or_create_by!({name: official.name, ocdid: ocdid_temp, title: title_temp, street: street, city: city, state: state, zip: zip, party: official.party, photo: photo})
      reps.push(rep)
    end
    reps
  end

end
