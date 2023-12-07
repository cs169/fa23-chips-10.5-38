# Run with < rspec spec/controllers/my_news_items_controller_spec.rb >

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  let(:representative) { instance_double(Representative, id: 1) }
  let(:news_item) { instance_double(NewsItem, id: 1) }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new news item' do
        news_item_params = { title: 'News Title', description: 'News Description', representative_id: representative.id }
        allow(NewsItem).to receive(:new).with(news_item_params).and_return(double(save: true, id: 1))
        post :create, params: { representative_id: representative.id, news_item: news_item_params }
        expect(response).to be_redirect
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested news item' do
      allow(NewsItem).to receive(:find).with(news_item.id.to_s).and_return(news_item)
      allow(news_item).to receive(:destroy).and_return(true)
      delete :destroy, params: { representative_id: representative.id, id: news_item.id }
      expect(response).to be_redirect
    end
  end
end