# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  #can do characterization tests in the fetures folder, can do cucumber tests file is .feature
  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end
      #if it exists, want to update it, otherwise create a new rep and push it
      #find the one we want, then use update! to update it 
      #otherwise, add to database
      if Representative.where("name = ?", official.name).exists?
        Representative.where(" = ?", official.name).update!(ocdid: ocdid_temp, title: title_temp)
      else
        rep = Representative.create!({ name: official.name, ocdid: ocdid_temp,
          title: title_temp })
        reps.push(rep)
    end

    reps
  end
end
