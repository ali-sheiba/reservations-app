# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  role            :integer          default(1), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_LOWER_email  (lower((email)::text)) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }
    it { should have_secure_password }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }
  end

  describe 'enums' do
    it { should define_enum_for(:role) }
  end

  describe '.login' do
    let(:user) { create(:user, email: 'a@a.com', password: 'password') }

    it 'return user object on valid data' do
      record = User.login(email: user.email, password: 'password')
      expect(record.id).to eq user.id
    end

    it 'return user object on valid data with upcase email' do
      record = User.login(email: user.email.upcase, password: 'password')
      expect(record.id).to eq user.id
    end

    it 'return false on non-exist email' do
      record = User.login(email: user.email, password: 'wrong-password')
      expect(record).to be false
    end

    it 'return false on wrong password' do
      user
      record = User.login(email: 'b@a.com', password: 'password')
      expect(record).to be false
    end
  end
end
