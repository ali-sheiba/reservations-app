# frozen_string_literal: true

# == Schema Information
#
# Table name: restaurants
#
#  id            :bigint(8)        not null, primary key
#  cuisines      :string           not null, is an Array
#  email         :string           not null
#  location      :text             not null
#  name          :string           not null
#  opening_hours :string           not null, is an Array
#  phone         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  manager_id    :bigint(8)        not null
#
# Indexes
#
#  index_restaurants_on_cuisines    (cuisines)
#  index_restaurants_on_manager_id  (manager_id)
#  index_restaurants_on_name        (name)
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => users.id) ON DELETE => cascade
#

class Restaurant < ApplicationRecord
  ## -------------------- Requirements -------------------- ##

  include RestaurantPresenter

  ## ----------------------- Scopes ----------------------- ##
  ## --------------------- Constants ---------------------- ##
  ## ----------------------- Enums ------------------------ ##
  ## -------------------- Associations -------------------- ##

  belongs_to :manager, class_name: 'User'

  has_many :reservations, dependent: :destroy
  has_many :guests,       through: :reservations, source: :user

  ## -------------------- Validations --------------------- ##

  validates :name,          presence: true
  validates :email,         presence: true, email: true
  validates :phone,         presence: true
  validates :location,      presence: true
  validates :cuisines,      presence: true
  validates :opening_hours, presence: true

  validate :owner_with_manager_role

  ## --------------------- Callbacks ---------------------- ##
  ## ------------------- Class Methods -------------------- ##
  ## ---------------------- Methods ----------------------- ##

  # Check if restaurant user have manager role
  def owner_with_manager_role
    errors.add(:manager, 'Manager shoudl have a manager role') unless manager.manager?
  end
end
