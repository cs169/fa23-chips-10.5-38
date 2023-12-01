# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  # Add the 'Issue' column to the NewsItem model
  enum issue: {
    "Free Speech": "Free Speech",
    "Immigration": "Immigration",
    "Terrorism": "Terrorism",
    "Social Security and Medicare": "Social Security and Medicare",
    "Abortion": "Abortion",
    "Student Loans": "Student Loans",
    "Gun Control": "Gun Control",
    "Unemployment": "Unemployment",
    "Climate Change": "Climate Change",
    "Homelessness": "Homelessness",
    "Racism": "Racism",
    "Tax Reform": "Tax Reform",
    "Net Neutrality": "Net Neutrality",
    "Religious Freedom": "Religious Freedom",
    "Border Security": "Border Security",
    "Minimum Wage": "Minimum Wage",
    "Equal Pay": "Equal Pay"
  }
  # Method to create a news item with the selected issue
  def self.create_with_issue(representative_id, issue)
    NewsItem.create!(
      representative_id: representative_id,
      issue: issue
    )
    end
  
end
