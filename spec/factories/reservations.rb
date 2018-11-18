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

FactoryBot.define do
  factory :reservation do
    restaurant_id { Restaurant.random.first&.id || FactoryBot.create(:restaurant).id }
    user_id       { User.guest.random.first&.id || FactoryBot.create(:user, role: :guest).id }
    status        { Reservation.statuses.keys.sample }
    note          { [nil, Faker::Lorem.paragraph].sample }
    covers        { rand(1..10) }
    start_time    do
      loop do
        date = Faker::Time.between(Date.today, 20.days.from_now, :day)
        break date unless booked_in_same_day?
      end
    end
  end
end
