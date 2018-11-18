# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ReservationsController, type: :controller do
  let(:valid_attributes) do
    FactoryBot.attributes_for(:reservation)
  end

  let(:invalid_attributes) do
    {
      covers: -1
    }
  end

  let(:admin_token) do
    @admin = create(:user, role: :admin)
    "Bearer #{JsonWebToken.encode(@admin.jwt_payload)}"
  end

  let(:guest_token) do
    guest = create(:user, role: :guest)
    "Bearer #{JsonWebToken.encode(guest.jwt_payload)}"
  end

  let(:manager_token) do
    manager = create(:user, role: :manager)
    "Bearer #{JsonWebToken.encode(manager.jwt_payload)}"
  end

  describe 'GET #index' do
    before(:all) do
      10.times { create(:user) rescue nil }
      10.times { create(:restaurant) rescue nil }
      10.times { create(:reservation) rescue nil }
      @guest = User.guest.random.first
      @manager = User.manager.random.first
    end

    it 'returns a success response for admin user with all reservations' do
      @request.headers['Authorization'] = admin_token
      get :index, params: {}
      expect(response).to be_successful
      expect(json['pagination']['total_entries']).to eq Reservation.count
    end

    it 'returns a success response for manager user with reservations of his resturant only' do
      @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
      get :index, params: {}
      expect(response).to be_successful
      expect(json['pagination']['total_entries']).to eq @manager.restaurant.reservations.count
    end

    it 'returns a success response for guest user with his own reservations only' do
      @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
      get :index, params: {}
      expect(response).to be_successful
      expect(json['pagination']['total_entries']).to eq @guest.reservations.count
    end
  end

  describe 'GET #show' do
    before(:all) do
       5.times { create(:use) rescue nil }
      10.times { create(:restaurant) rescue nil }
      @guest = User.guest.random.first
      @manager = User.manager.random.first
    end

    it 'returns a success response for admin user' do
      reservation = create(:reservation)

      @request.headers['Authorization'] = admin_token
      get :show, params: { id: reservation.to_param }
      expect(response).to be_successful
    end

    context 'restaurant manager' do
      it 'returns a success response for manager restaurant reservation' do
        reservation = create(:reservation, restaurant_id: @manager.restaurant.id)

        @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
        get :show, params: { id: reservation.to_param }
        expect(response).to be_successful
      end

      it 'returns a not found response if reservation not belongs to restaurant' do
        restaurant = Restaurant.where.not(id: @manager.restaurant.id).random.first
        reservation = create(:reservation, restaurant_id: restaurant.id)

        @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
        get :show, params: { id: reservation.to_param }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'guest user' do
      it 'returns a success response for same user reservation' do
        reservation = create(:reservation, user_id: @guest.id)

        @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
        get :show, params: { id: reservation.to_param }
        expect(response).to be_successful
      end

      it 'returns a not found response if reservation not belongs same user' do
        user = User.where.not(id: @guest.id).random.first
        reservation = create(:reservation, user_id: user.id)

        @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
        get :show, params: { id: reservation.to_param }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Reservation' do
        expect do
          @request.headers['Authorization'] = admin_token
          post :create, params: valid_attributes
        end.to change(Reservation, :count).by(1)
      end

      it 'renders a JSON response with the new reservation' do
        @request.headers['Authorization'] = admin_token
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(json).to include('reservation')
        expect(json['reservation']['id']).to eq Reservation.last.id
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new reservation' do
        @request.headers['Authorization'] = admin_token
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'roles' do
      before(:all) do
        10.times { create(:user) rescue nil }
        10.times { create(:restaurant) rescue nil }
        @manager = create(:restaurant).manager
        @guest = create(:user, role: :guest)
      end

      it 'created reservation by manager will belongs to manager\s restaurant even if passed different restaurant id' do
        res = @manager.restaurant
        params = valid_attributes
        params[:restaurant_id] = Restaurant.where.not(id: res.id).pluck(:id).sample

        @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
        post :create, params: params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(json['reservation']['id']).to eq Reservation.last.id
        expect(json['reservation']['restaurant']['id']).to eq res.id
      end

      it 'created reservation by guest will belongs to same user even if passed different user id' do
        params = valid_attributes
        params[:usre_id] = User.where.not(id: @guest.id).pluck(:id).sample

        @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
        post :create, params: params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(json['reservation']['id']).to eq Reservation.last.id
        expect(json['reservation']['user']['id']).to eq @guest.id
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { covers: 100 }
      end

      it 'updates the requested reservation' do
        reservation = create(:reservation)
        @request.headers['Authorization'] = admin_token
        put :update, params: { id: reservation.to_param }.merge(new_attributes)
        reservation.reload
        expect(reservation.covers).to eq(new_attributes[:covers])
      end

      it 'renders a JSON response with the reservation' do
        reservation = create(:reservation)

        @request.headers['Authorization'] = admin_token
        put :update, params: { id: reservation.to_param }.merge(valid_attributes)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the reservation' do
        reservation = create(:reservation)

        @request.headers['Authorization'] = admin_token
        put :update, params: { id: reservation.to_param }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'roles' do
      before(:all) do
        10.times { create(:user) rescue nil }
        10.times { create(:restaurant) rescue nil }
        @manager = create(:restaurant).manager
        @guest = create(:user, role: :guest)
        20.times { create(:reservation) rescue nil }
      end

      context 'restaurant manager' do
        it 'returns a success response if manager updated his restaurant reservation' do
          reservation = create(:reservation, restaurant_id: @manager.restaurant.id)

          @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
          put :update, params: { id: reservation.to_param }.merge(valid_attributes)
          expect(response).to have_http_status(:ok)
        end

        it 'returns a not found response if updated reservation not belongs to restaurant manager' do
          res = @manager.restaurant
          reservation = create(:reservation, restaurant_id: Restaurant.where.not(id: res.id).pluck(:id).sample)

          @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
          put :update, params: { id: reservation.to_param }.merge(valid_attributes)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'guest user' do
        it 'returns a success response if user updated his reservation' do
          reservation = create(:reservation, user_id: @guest.id)

          @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
          put :update, params: { id: reservation.to_param }.merge(valid_attributes)
          expect(response).to have_http_status(:ok)
        end

        it 'returns a not found response if updated reservation not belongs same user' do
          user = User.where.not(id: @guest.id).random.first
          reservation = create(:reservation, user_id: user.id)

          @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
          put :update, params: { id: reservation.to_param }.merge(valid_attributes)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested reservation' do
      reservation = create(:reservation)
      expect do
        @request.headers['Authorization'] = admin_token
        delete :destroy, params: { id: reservation.to_param }
      end.to change(Reservation, :count).by(-1)
    end

    context 'roles' do
      before(:all) do
        10.times { create(:user) rescue nil }
        10.times { create(:restaurant) rescue nil }
        @manager = create(:restaurant).manager
        @guest = create(:user, role: :guest)
        20.times { create(:reservation) rescue nil }
      end

      context 'restaurant manager' do
        it 'returns a success response if manager destroys his restaurant reservation' do
          reservation = create(:reservation, restaurant_id: @manager.restaurant.id)

          expect do
            @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
            delete :destroy, params: { id: reservation.to_param }
          end.to change(Reservation, :count).by(-1)
        end

        it 'returns a not found response if destroys reservation not belongs to restaurant manager' do
          res = @manager.restaurant
          reservation = create(:reservation, restaurant_id: Restaurant.where.not(id: res.id).pluck(:id).sample)

          expect do
            @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@manager.jwt_payload)}"
            delete :destroy, params: { id: reservation.to_param }
          end.to change(Reservation, :count).by(0)
        end
      end

      context 'guest user' do
        it 'returns a success response if user destroys his reservation' do
          reservation = create(:reservation, user_id: @guest.id)

          expect do
            @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
            delete :destroy, params: { id: reservation.to_param }
          end.to change(Reservation, :count).by(-1)
        end

        it 'returns a not found response if destroys reservation not belongs same user' do
          user = User.where.not(id: @guest.id).random.first
          reservation = create(:reservation, user_id: user.id)

          expect do
            @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(@guest.jwt_payload)}"
            delete :destroy, params: { id: reservation.to_param }
          end.to change(Reservation, :count).by(0)
        end
      end
    end
  end
end
