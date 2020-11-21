# frozen_string_literal: true

# == Schema Information
#
# Table name: places
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  country    :string           not null
#  lat        :float            not null
#  long       :float            not null
#  name       :string           not null
#  rating     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :place do
    sequence(:name) { |n| "place_name_#{n}" }
    sequence(:address) { |n| "adress_#{n}" }
    sequence(:lat) { |_| Faker::Number.between(from: -180.0, to: 180.0).floor(6) }
    sequence(:long) { |_| Faker::Number.between(from: -180.0, to: 180.0).floor(6) }
    sequence(:rating) { |_| Faker::Number.between(from: 0.0, to: 10.0).floor(1) }
    sequence(:country) { |n| "country_#{n}" }
  end
end
