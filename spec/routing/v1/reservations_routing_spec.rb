# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ReservationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/reservations').to route_to('v1/reservations#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/reservations/1').to route_to('v1/reservations#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/reservations').to route_to('v1/reservations#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/reservations/1').to route_to('v1/reservations#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/reservations/1').to route_to('v1/reservations#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/reservations/1').to route_to('v1/reservations#destroy', id: '1')
    end
  end
end
