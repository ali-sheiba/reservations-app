# frozen_string_literal: true

module GuestPresenter
  extend ActiveSupport::Concern

  included do
    acts_as_api

    api_accessible :base do |t|
      t.add :id
      t.add :first_name
      t.add :last_name
      t.add :phone
      t.add :email
      t.add :created_at
      t.add :updated_at
    end

    api_accessible :index, extend: :base

    api_accessible :show, extend: :index
  end
end
