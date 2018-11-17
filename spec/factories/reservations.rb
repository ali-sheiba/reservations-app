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

FactoryBot.define do
  factory :reservation do
    restaurant    { Restaurant.random.first || FactoryBot.create(:restaurant) }
    guest         { Guest.random.first || FactoryBot.create(:guest) }
    start_time    { Faker::Time.between(Date.today, 2.days.from_now, :day) }
    status        { Reservation.statuses.keys.sample }
    note          { [nil, Faker::Lorem.paragraph].sample }
    covers        { rand(1..10) }
  end
end
