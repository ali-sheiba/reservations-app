# frozen_string_literal: true

# == Schema Information
#
# Table name: guests
#
#  id         :bigint(8)        not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  phone      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_guests_on_email  (email)
#  index_guests_on_phone  (phone)
#

require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }
  end

  describe 'associations' do
    it { should have_many(:reservations) }
    it { should have_many(:guests).through(:reservations) }
  end
end
