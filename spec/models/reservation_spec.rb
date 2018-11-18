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

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:covers) }
    it { should validate_numericality_of(:covers).only_integer.is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }
  end

  describe 'booking validations' do
    before(:all) do
      date = Date.today
      user = create(:user, role: :guest)
      restaurant = create(:restaurant)
      @r_a = create(:reservation, restaurant: restaurant, user: user, start_time: Faker::Time.between(date, date, :day))
      @r_b = build(:reservation, restaurant: restaurant, user: user, start_time: Faker::Time.between(date, date, :day))
    end

    describe 'booked_in_same_day?' do
      it 'should return true if same user booked in same restaurant in same day' do
        expect(@r_b.booked_in_same_day?).to be true
      end

      it 'should return fasle if same user booked in different day or different restaurant' do
        expect(@r_a.booked_in_same_day?).to be false
      end
    end

    describe 'book_once_aday' do
      it 'should validate if user booked in same restaurant in same day' do
        expect(@r_b.valid?).to be false
        expect(@r_b.errors.messages).to include(user: ['Guest can book only once a day'])
      end
    end
  end
end
