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

  ####### Restaurants #######

  # Any one can show restaurants
  power :restaurants_index, :restaurant_show do
    Restaurant
  end

  # Admins only can create, update and delete
  power :creatable_restaurant,
        :updatable_restaurant,
        :destroyable_restaurant do
    return Restaurant if current_user.admin?

    raise Consul::Powerless
  end

  ####### Reservations #######

  power :reservations_index,
        :reservation_show,
        :creatable_reservation,
        :updatable_reservation,
        :destroyable_reservation do
    # Admin can check all reservations
    return Reservation.includes(:user, :restaurant) if current_user.admin?

    # Restaurant manager can check his own restaurant reservations only
    return current_user.restaurant.reservations.includes(:user, :restaurant) if current_user.manager?

    # Guests can only check there own resurvations
    return current_user.reservations.includes(:user, :restaurant) if current_user.guest?

    raise Consul::Powerless
  end
end
