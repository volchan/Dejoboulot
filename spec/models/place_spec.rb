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
require 'rails_helper'

RSpec.describe Place, type: :model do
  subject { build(:place) }

  let(:place) { subject }

  it 'has a valid factory' do
    expect(place).to be_valid
  end

  describe '# Associations' do; end

  describe '# Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.not_to validate_presence_of(:rating) }

    numericality_check_options = [
      [:lat, -180.0, 180.0],
      [:long, -180.0, 180.0],
    ]

    numericality_check_options.each do |(attribute, min, max)|
      it { is_expected.to validate_presence_of(attribute) }

      it do
        expect(place).to(
          validate_numericality_of(attribute)
            .is_greater_than_or_equal_to(min)
            .is_less_than_or_equal_to(max),
        )
      end
    end

    it do
      expect(place).to(
        validate_numericality_of(:rating)
          .is_greater_than_or_equal_to(0.0)
          .is_less_than_or_equal_to(10.0),
      )
    end
  end
end
