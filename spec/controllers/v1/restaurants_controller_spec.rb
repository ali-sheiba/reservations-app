# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RestaurantsController, type: :controller do
  let(:valid_attributes) do
    FactoryBot.attributes_for(:restaurant)
  end

  let(:invalid_attributes) do
    {
      email: 'invalid-email'
    }
  end

  let(:admin_token) do
    user = create(:user, role: :admin)
    "Bearer #{JsonWebToken.encode(user.jwt_payload)}"
  end

  let(:guest_token) do
    user = create(:user, role: :guest)
    "Bearer #{JsonWebToken.encode(user.jwt_payload)}"
  end

  let(:manager_token) do
    user = create(:user, role: :manager)
    "Bearer #{JsonWebToken.encode(user.jwt_payload)}"
  end

  describe 'GET #index' do
    %w[admin manager guest].each do |role|
      it "returns a success response for #{role} user" do
        10.times { create(:restaurant) rescue nil }

        @request.headers['Authorization'] = send("#{role}_token")
        get :index, params: {}
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    %w[admin manager guest].each do |role|
      it "returns a success response for #{role} user" do
        restaurant = create(:restaurant)

        @request.headers['Authorization'] = send("#{role}_token")
        get :show, params: { id: restaurant.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Restaurant' do
        expect do
          @request.headers['Authorization'] = admin_token
          post :create, params: valid_attributes
        end.to change(Restaurant, :count).by(1)
      end

      it 'renders a JSON response with the new restaurant' do
        @request.headers['Authorization'] = admin_token
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(json).to include('restaurant')
        expect(json['restaurant']['id']).to eq Restaurant.last.id
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new restaurant' do
        @request.headers['Authorization'] = admin_token
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'reject unauthorized roles' do
      %w[manager guest].each do |role|
        it "renders forbidden response for #{role} on create restaurant" do
          @request.headers['Authorization'] = send("#{role}_token")
          post :create, params: valid_attributes
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'New Restaurant' }
      end

      it 'updates the requested restaurant' do
        restaurant = create(:restaurant)
        @request.headers['Authorization'] = admin_token
        put :update, params: { id: restaurant.to_param }.merge(new_attributes)
        restaurant.reload
        expect(restaurant.name).to eq(new_attributes[:name])
      end

      it 'renders a JSON response with the restaurant' do
        restaurant = create(:restaurant)

        @request.headers['Authorization'] = admin_token
        put :update, params: { id: restaurant.to_param }.merge(valid_attributes)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the restaurant' do
        restaurant = create(:restaurant)

        @request.headers['Authorization'] = admin_token
        put :update, params: { id: restaurant.to_param }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'reject unauthorized roles' do
      %w[manager guest].each do |role|
        it "renders forbidden response for #{role} on update restaurant" do
          restaurant = create(:restaurant)

          @request.headers['Authorization'] = send("#{role}_token")
          put :update, params: { id: restaurant.to_param }.merge(valid_attributes)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested restaurant' do
      restaurant = create(:restaurant)
      expect do
        @request.headers['Authorization'] = admin_token
        delete :destroy, params: { id: restaurant.to_param }
      end.to change(Restaurant, :count).by(-1)
    end

    context 'reject unauthorized roles' do
      %w[manager guest].each do |role|
        it "renders forbidden response for #{role} on update restaurant" do
          restaurant = create(:restaurant)

          @request.headers['Authorization'] = send("#{role}_token")
          delete :destroy, params: { id: restaurant.to_param }
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
