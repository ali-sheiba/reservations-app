# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RestaurantsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/restaurants').to route_to('v1/restaurants#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/restaurants/1').to route_to('v1/restaurants#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/restaurants').to route_to('v1/restaurants#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/restaurants/1').to route_to('v1/restaurants#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/restaurants/1').to route_to('v1/restaurants#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/restaurants/1').to route_to('v1/restaurants#destroy', id: '1')
    end
  end
end
