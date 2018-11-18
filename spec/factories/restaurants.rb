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

FactoryBot.define do
  factory :restaurant do
    manager         { User.manager.random.first || FactoryBot.create(:user, role: :manager) }
    name            { Faker::Company.name }
    email           { Faker::Internet.email(name) }
    location        { Faker::Address.full_address }
    phone           { Faker::PhoneNumber.phone_number }
    opening_hours   { ['Satarday to Thursday: 10:00 A.M – 10:00 P.M', 'Friday to Sunday: 10:00 A.M – 12:00 midnight'] }
    cuisines        do
      %w[
        Arabian
        Chinese
        Italian
        Japanese
        Thia
        American
        Indian
        French
        Maxican
        Spanish
        Greek
        Breakfast
        Noodle
        Turkish
      ].sample(rand(2..5))
    end
  end
end
