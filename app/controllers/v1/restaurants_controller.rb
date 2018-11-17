# frozen_string_literal: true

class V1::RestaurantsController < V1::BaseController
  power :restaurants, map: {
    [:index] => :restaurants_index,
    [:show] => :restaurant_show,
    [:create] => :creatable_restaurant,
    [:update] => :updatable_restaurant,
    [:destroy] => :destroyable_restaurant
  }, as: :restaurant_scope

  # # GET /v1/restaurants
  # def index; end

  # # GET /v1/restaurants/1
  # def show; end

  # # POST /v1/restaurants
  # def create; end

  # # PATCH/PUT /v1/restaurants/1
  # def update; end

  # # DELETE /v1/restaurants/1
  # def destroy; end

  private

  def restaurant_params
    params.permit(
      :name,
      :email,
      :phone,
      :location,
      :manager_id,
      cuisines: [],
      opening_hours: []
    )
  end
end
