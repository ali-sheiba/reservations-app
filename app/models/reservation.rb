# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id            :bigint(8)        not null, primary key
#  covers        :integer          default(1), not null
#  note          :text
#  start_time    :datetime         not null
#  status        :integer          default("booked"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  restaurant_id :bigint(8)        not null
#  user_id       :bigint(8)        not null
#
# Indexes
#
#  index_reservations_on_restaurant_id  (restaurant_id)
#  index_reservations_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (restaurant_id => restaurants.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
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
  belongs_to :user

  ## -------------------- Validations --------------------- ##

  validates :start_time, presence: true
  validates :status,     presence: true
  validates :covers,     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validate :book_once_aday

  ## --------------------- Callbacks ---------------------- ##
  ## ------------------- Class Methods -------------------- ##
  ## ---------------------- Methods ----------------------- ##

  def book_once_aday
    errors.add(:user, 'Guest can book only once a day') if booked_in_same_day?
  end

  def booked_in_same_day?
    self.class
        .where(restaurant_id: restaurant_id)
        .where(user_id: user_id)
        .where('date(start_time) in (?)', start_time&.to_date)
        .where.not(id: id)
        .exists?
  end
end
