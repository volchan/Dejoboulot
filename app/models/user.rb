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
class User < ApplicationRecord
  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :polls, dependent: :destroy, foreign_key: :created_by_id, inverse_of: :created_by

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /^[a-zA-Z0-9_.]*$/, multiline: true }

  validate :validate_username

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    conditions[:email]&.downcase!
    if login
      where(conditions.to_h).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    elsif conditions.key?(:username) || conditions.key?(:email)
      find_by(conditions.to_h)
    end
  end

  def login
    @login || username || email
  end

  private

  def validate_username
    return unless User.exists?(email: username)

    errors.add(:username, :invalid)
  end
end
