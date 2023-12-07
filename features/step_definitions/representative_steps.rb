# frozen_string_literal: true

Given('there is a representative with name {string} and other details') do |name|
  Representative.create!(name: name, ocdid: 'ocd123', title: 'Representative', party: 'Example Party')
end

When('I visit the representative details page') do
  # representative = Representative.last
  # What's the path for representative?
  # visit search_representatives_path(representative)
end

Then('I should see the representative details displayed') do
  representative = Representative.last
  expect(page).to have_content('Representative Details')
  expect(page).to have_content("Name: #{representative.name}")
  expect(page).to have_content("OCID: #{representative.ocdid}")
  expect(page).to have_content("Title: #{representative.title}")
  expect(page).to have_content("Street: #{representative.street}")
  expect(page).to have_content("City: #{representative.city}")
  expect(page).to have_content("State: #{representative.state}")
  expect(page).to have_content("Zip: #{representative.zip}")
  expect(page).to have_content("Party: #{representative.party}")
  expect(page).to have_css("img[src*='#{representative.photo.url}']")
end
