# frozen_string_literal: true

module RestaurantPresenter
  extend ActiveSupport::Concern

  included do
    acts_as_api

    api_accessible :base do |t|
      t.add :id
      t.add :name
    end

    api_accessible :index, extend: :base do |t|
      t.add :phone
      t.add :email
      t.add :location
      t.add :opening_hours
      t.add :cuisines
    end

    api_accessible :show, extend: :index
  end
end
