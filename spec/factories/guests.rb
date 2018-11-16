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

FactoryBot.define do
  factory :guest do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.free_email(first_name) }
    phone       { Faker::PhoneNumber.phone_number }
  end
end
