# frozen_string_literal: true

class Power
  include Consul::Power

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  # allow evryone to use sessions api
  power :sessions do
    true
  end

  # Any one can show resturants
  power :restaurants_index, :restaurant_show do
    Restaurant
  end

  # Admins only can create, update and delete
  power :creatable_restaurant,
        :updatable_restaurant,
        :destroyable_restaurant do
    return Restaurant if current_user&.admin?

    raise Consul::Powerless
  end
end
