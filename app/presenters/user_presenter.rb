# frozen_string_literal: true

module UserPresenter
  extend ActiveSupport::Concern

  included do
    acts_as_api

    api_accessible :base do |t|
      t.add :id
      t.add :first_name
      t.add :last_name
    end

    api_accessible :index, extend: :base

    api_accessible :show, extend: :index
  end
end
