# frozen_string_literal: true

# == Schema Information
#
# Table name: proposals
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  place_id   :bigint           not null
#  poll_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_proposals_on_place_id  (place_id)
#  index_proposals_on_poll_id   (poll_id)
#  index_proposals_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (place_id => places.id)
#  fk_rails_...  (poll_id => polls.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :proposal do
    user
    poll
    place
  end
end
