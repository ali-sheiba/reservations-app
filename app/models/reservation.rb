# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id            :bigint(8)        not null, primary key
#  covers        :integer          default(1), not null
#  note          :text
#  start_time    :datetime         not null
#  status        :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  guest_id      :bigint(8)        not null
#  restaurant_id :bigint(8)        not null
#
# Indexes
#
#  index_reservations_on_guest_id       (guest_id)
#  index_reservations_on_restaurant_id  (restaurant_id)
#
# Foreign Keys
#
#  fk_rails_...  (guest_id => guests.id) ON DELETE => cascade
#  fk_rails_...  (restaurant_id => restaurants.id) ON DELETE => cascade
#

class Reservation < ApplicationRecord
  ## -------------------- Requirements -------------------- ##

  include ReservationPresenter

  ## ----------------------- Scopes ----------------------- ##
  ## --------------------- Constants ---------------------- ##
  ## ----------------------- Enums ------------------------ ##

  enum status: {
    booked: 0,
    seated: 1,
    finished: 2,
    canceled: 3,
    no_show: 4
  }

  ## -------------------- Associations -------------------- ##

  belongs_to :restaurant
  belongs_to :guest

  ## -------------------- Validations --------------------- ##

  validates :start_time, presence: true
  validates :status,     presence: true
  validates :covers,     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  ## --------------------- Callbacks ---------------------- ##
  ## ------------------- Class Methods -------------------- ##
  ## ---------------------- Methods ----------------------- ##
end
