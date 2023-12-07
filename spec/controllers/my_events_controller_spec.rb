# Run with < rspec spec/controllers/my_events_controller_spec.rb >

# expect(response).to be_redirect

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyEventsController do
  it 'new' do
    get :new
    expect(response).to redirect_to(login_path)
  end

  it 'edit' do
    get :edit, params: { id: 1 }
    expect(response).to redirect_to(login_path)
  end

  it 'create' do
    post :create
    expect(response).to redirect_to(login_path)
  end

  it 'update' do
    patch :update, params: { id: 1 }
    expect(response).to redirect_to(login_path)
  end

  it 'destroy' do
    delete :destroy, params: { id: 1 }
    expect(response).to redirect_to(login_path)
  end
end
