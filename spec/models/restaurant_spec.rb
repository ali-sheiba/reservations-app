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
  end

  describe 'associations' do
    it { should belong_to(:manager).class_name('User') }
    it { should have_many(:reservations) }
    it { should have_many(:guests).through(:reservations) }
  end
end
