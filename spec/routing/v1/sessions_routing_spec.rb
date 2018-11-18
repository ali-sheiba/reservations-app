# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/v1/sessions').to route_to('v1/sessions#create')
    end
  end
end
