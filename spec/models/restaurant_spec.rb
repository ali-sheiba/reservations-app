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

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:cuisines) }
    it { should validate_presence_of(:opening_hours) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }
    it { should validate_uniqueness_of(:manager_id).ignoring_case_sensitivity }
  end

  describe 'associations' do
    it { should belong_to(:manager).class_name('User') }
    it { should have_many(:reservations) }
    it { should have_many(:guests).through(:reservations) }
  end

  describe 'owner_with_manager_role' do
    it 'should validate restaurant manager user to have manager role' do
      user_a = create(:user, role: :manager)
      restaurant_a = build(:restaurant, manager: user_a)
      expect(restaurant_a.valid?).to be true

      user_b = create(:user, role: :guest)
      restaurant_b = build(:restaurant, manager: user_b)
      expect(restaurant_b.valid?).to be false
      expect(restaurant_b.errors.messages).to include(manager: ['Manager shoudl have a manager role'])
    end
  end
end
