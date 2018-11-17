# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Restaurants', type: :request do
  describe 'GET /v1_restaurants' do
    it 'works! (now write some real specs)' do
      get v1_restaurants_path
      expect(response).to have_http_status(200)
    end
  end
end
