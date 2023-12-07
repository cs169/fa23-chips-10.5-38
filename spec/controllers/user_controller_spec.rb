# frozen_string_literal: true

# Run with < rspec spec/controllers/user_controller_spec.rb >

# spec/controllers/user_controller_spec.rb

require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe '#profile' do
    let(:user) { instance_double(User, id: 1) }

    context 'when user is logged in' do
      before do
        allow(controller).to receive(:session).and_return(current_user_id: user.id)
        allow(User).to receive(:find).with(user.id).and_return(user)
      end

      it 'assigns the current user to @user' do
        get :profile
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the profile template' do
        get :profile
        expect(response).to render_template('profile')
      end
    end

    context 'when user is not logged in' do
      before do
        allow(controller).to receive(:session).and_return({})
      end

      it 'redirects to the login page' do
        get :profile
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
