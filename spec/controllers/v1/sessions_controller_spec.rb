# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::SessionsController, type: :controller do
  describe 'GET #create' do
    it 'returns http unprocessable_entity if no email or password' do
      post :create
      expect(response).to have_http_status(:unprocessable_entity)
    end

    pending 'returns http created with JWT if valid email and password' do
      user = create(:user, password: 'psasword')
      post :create, params: { email: user.email, password: 'psasword' }, as: :json
      expect(response).to have_http_status(:success)
      expect(json).to include('token')
    end

    it 'returns http bad_request if email or password are invalid' do
      post :create, params: { email: 'xxx', password: 'psasword' }, as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
