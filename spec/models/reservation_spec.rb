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
    it { should belong_to(:guest) }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }
  end
end