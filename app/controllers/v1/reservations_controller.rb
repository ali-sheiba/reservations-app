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
    params.permit(
      :covers,
      :note,
      :start_time
    )
  end

  def params_processed
    # Allow user to pass restaurant id
    resource_params.merge!(params.permit(:restaurant_id)) if current_user.guest?
    # Allow restaurant owner to pass user id
    resource_params.merge!(params.permit(:user_id)) if current_user.manager?
    # Allow admin to pass restaurant user id
    resource_params.merge!(params.permit(:restaurant_id, :user_id)) if current_user.admin?
    # Allow admin and manager to change status
    resource_params.merge!(params.permit(:status)) if current_user.manager? || current_user.admin?

    resource_params
  end
end
