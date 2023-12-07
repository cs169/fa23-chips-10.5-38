# frozen_string_literal: true

class CampaignFinance < ApplicationRecord
  def self.get_top(cycle, category)
    api_key = Rails.application.credentials[:PROPUBLICA_API_KEY]
    category = category.downcase.sub(' ', '-')
    url = "https://api.propublica.org/campaign-finance/v1/#{cycle}/candidates/leaders/#{category}.json"
    conn = Faraday.new do |faraday|
      faraday.headers['X-API-Key'] = api_key
    end
    JSON.parse(conn.get(url).body)['results']
  end

  def self.cycle
    [2010, 2012, 2014, 2016, 2018, 2020]
  end

  def self.category
    { 'Candidate Loan' => 'candidate-loan.json', 'Contribution Total' => 'contribution-total.json',
      'Debts Owed' => 'debts-owed.json', 'Disbursements Total' => 'disbursements-total.json',
      'Individual Total' => 'individual-total.json', 'End Cash' => 'end-cash.json',
      'Receipts Total' => 'receipts-total.json', 'Pac Total' => 'pac-total.json',
      'Refund Total' => 'refund-total.json' }
  end
end
