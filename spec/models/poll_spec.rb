# frozen_string_literal: true

# == Schema Information
#
# Table name: polls
#
#  id            :bigint           not null, primary key
#  due_at        :datetime
#  scheduled_at  :datetime
#  slug          :string
#  status        :string           default("pending")
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :integer
#
# Indexes
#
#  index_polls_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Poll, type: :model do
  subject { build(:poll) }

  setup do
    Timecop.freeze
  end

  teardown do
    Timecop.return
  end

  let(:poll) { subject }

  it 'has a valid factory' do
    expect(poll).to be_valid
  end

  describe '# Associations' do
    it { is_expected.to belong_to(:created_by).class_name('User').inverse_of(:polls) }
  end

  describe '# Validations' do
    let(:now) { Time.current }

    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }

    it 'is expected automatically generate a hex slug' do
      expect(build(:poll).slug).not_to match(/\H/)
    end

    it { is_expected.to validate_presence_of(:scheduled_at) }
    it { is_expected.to validate_presence_of(:due_at) }

    it 'is expected not to allow #scheduled_at to be on <Time.current>' do
      expect(build(:poll, scheduled_at: now, due_at: now - 1.hour)).not_to be_valid
    end

    it 'is expected not to allow #scheduled_at to be before <Time.current>' do
      expect(build(:poll, scheduled_at: now - 1.second, due_at: now - 1.hour)).not_to be_valid
    end

    it 'is expected not to allow #due_at to be on <Time.current>' do
      expect(build(:poll, scheduled_at: now + 1.hour, due_at: now)).not_to be_valid
    end

    it 'is expected not to allow #due_at to be before <Time.current>' do
      expect(build(:poll, scheduled_at: now + 1.hour, due_at: now - 1.hour)).not_to be_valid
    end

    it 'is expected not to allow #scheduled_at to be before #due_at' do
      expect(build(:poll, scheduled_at: now + 1.hour, due_at: now + 2.hours)).not_to be_valid
    end

    it 'is expected to allow #due_at to be before #scheduled' do
      expect(build(:poll, scheduled_at: now + 1.hour, due_at: now + 30.minutes)).to be_valid
    end
  end
end
