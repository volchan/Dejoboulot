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
FactoryBot.define do
  factory :poll do
    slug { SecureRandom.hex(10) }
    sequence(:scheduled_at) { |_| Time.current + 1.hour }
    sequence(:due_at) { |_| Time.current + 30.minutes }
    created_by
    status { 'pending' }
    sequence(:title) { |n| "title_#{n}" }
  end
end
