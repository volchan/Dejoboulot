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
require 'rails_helper'

RSpec.describe Proposal, type: :model do
  subject { build(:proposal) }

  let(:proposal) { subject }

  it 'has a valid factory' do
    expect(proposal).to be_valid
  end

  describe '# Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:poll) }
    it { is_expected.to belong_to(:place) }
  end
end
