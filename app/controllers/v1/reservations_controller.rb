# frozen_string_literal: true

class V1::ReservationsController < V1::BaseController
  power :reservations, map: {
    [:index] => :reservations_index,
    [:show] => :reservation_show,
    [:create] => :creatable_reservation,
    [:update] => :updatable_reservation,
    [:destroy] => :destroyable_reservation
  }, as: :reservations_scope

  # # GET /v1/reservations
  # def index; end

  # # GET /v1/reservations/1
  # def show; end

  # # POST /v1/reservations
  # def create; end

  # # PATCH/PUT /v1/reservations/1
  # def update; end

  # # DELETE /v1/reservations/1
  # def destroy; end

  private

  def reservation_params
    params.permit
  end
end
