# frozen_string_literal: true

module ReservationPresenter
  extend ActiveSupport::Concern

  included do
    acts_as_api

    api_accessible :base do |t|
      t.add :id
      t.add :restaurant_id
      t.add :guest_id
      t.add :status
      t.add :start_time
      t.add :covers
      t.add :note
    end

    api_accessible :index, extend: :base

    api_accessible :show, extend: :index
  end
end
