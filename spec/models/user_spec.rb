# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  firstname              :string           not null
#  lastname               :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  let(:user) { subject }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe '# Associations' do; end

  describe '# Validations' do
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to allow_value('toto123._').for(:username) }
    it { is_expected.not_to allow_value('toto ').for(:username) }
    it { is_expected.not_to allow_value('toto@').for(:username) }

    it 'is expected not to allow duplicated usernames' do
      first_user = create(:user)
      expect(build(:user, username: first_user.username)).not_to be_valid
    end
  end

  describe '# Instance Methods' do
    it { is_expected.to respond_to(:login) }
  end
end
