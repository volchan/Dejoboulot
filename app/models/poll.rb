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
class Poll < ApplicationRecord
  belongs_to :created_by, class_name: 'User', inverse_of: :polls

  has_many :proposals, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validates :scheduled_at, presence: true, timeliness: { after: :due_at, type: :datetime }
  validates :due_at, presence: true, timeliness: { before: :scheduled_at, after: Time.current, type: :datetime }

  validate :scheduled_at_after_now
  validate :due_at_after_now

  enum status: { pending: 'pending', voting: 'voting', closed: 'closed', canceled: 'canceled' }

  after_initialize :init_slug, if: :new_record?

  private

  def init_slug
    self.slug = loop do
      new_slug = SecureRandom.hex(10)
      break new_slug unless Poll.exists?(slug: new_slug)
    end
  end

  def scheduled_at_after_now
    validates_datetime :scheduled_at, after: Time.current
  end

  def due_at_after_now
    validates_datetime :due_at, after: Time.current
  end
end
