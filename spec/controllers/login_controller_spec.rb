# frozen_string_literal: true

# Run with < rspec spec/controllers/login_controller_spec.rb >

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe '#login' do
    it 'render login screen' do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe '#logout' do
    it 'clears the current_user_id session variable' do
      session[:current_user_id] = 0
      get :logout
      expect(session[:current_user_id]).to be_nil
    end

    it 'redirect to root_path with flash' do
      get :logout
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('You have successfully logged out.')
    end
  end
end
