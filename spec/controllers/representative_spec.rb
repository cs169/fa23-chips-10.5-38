# frozen_string_literal: true

# Run with < rspec spec/controllers/representative_spec.rb >

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  describe 'GET #show' do
    context 'when representative exists' do
      it 'renders the show template' do
        representative = Representative.create(name: 'First Last', party: 'Independent')
        get :show, params: { id: representative.id }
        expect(response).to render_template(:show)
        expect(assigns(:representative)).to eq(representative)
      end
    end

    context 'when representative does not exist' do
      it 'redirects to representatives_path with an alert' do
        get :show, params: { id: 'nonexistent_id' }
        expect(response).to redirect_to(representatives_path)
        expect(flash[:alert]).to eq('no one found')
      end
    end
  end
end
