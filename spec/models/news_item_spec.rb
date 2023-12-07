# frozen_string_literal: true

# Run with < rspec spec/models/news_item_spec.rb >

require 'rails_helper'

FAKE_CLASS = 'fake_class'

RSpec.describe NewsItem, type: :model do
  describe '.find_for' do
    let(:representative) { instance_double(Representative, 'Representative', id: 1) }
    let(:news_item) { instance_double(described_class) }

    context 'when a news item exists for the representative' do
      before do
        allow(described_class).to receive(:find_by).with(representative_id: representative.id).and_return(news_item)
      end

      it 'returns the news item' do
        found_news_item = described_class.find_for(representative.id)
        expect(found_news_item).to eq(news_item)
      end
    end

    context 'when no news item exists for the representative' do
      before do
        allow(described_class).to receive(:find_by).with(representative_id: 999).and_return(nil)
      end

      it 'returns nil' do
        found_news_item = described_class.find_for(999) # Non-existent representative id
        expect(found_news_item).to be_nil
      end
    end
  end
end
