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
class Place < ApplicationRecord
  GEOLOC_MIN = -180.0
  GEOLOC_MAX = 180.0

  validates :name, presence: true
  validates :address, presence: true
  validates :country, presence: true
  validates :lat,
            presence: true,
            numericality: {
              greater_than_or_equal_to: GEOLOC_MIN,
              less_than_or_equal_to: GEOLOC_MAX,
            }
  validates :long,
            presence: true,
            numericality: {
              greater_than_or_equal_to: GEOLOC_MIN,
              less_than_or_equal_to: GEOLOC_MAX,
            }
  validates :rating, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 10.0, allow_nil: true }
end
