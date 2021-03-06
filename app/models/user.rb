# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  role            :integer          default("guest"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_LOWER_email  (lower((email)::text)) UNIQUE
#

class User < ApplicationRecord
  ## -------------------- Requirements -------------------- ##

  has_secure_password
  include UserPresenter

  ## ----------------------- Scopes ----------------------- ##
  ## --------------------- Constants ---------------------- ##
  ## ----------------------- Enums ------------------------ ##

  enum role: {
    admin: 0, # System super admin
    guest: 1, # Normal User / Guest
    manager: 2 # Restaurant owner
  }

  ## -------------------- Associations -------------------- ##

  has_one :restaurant, dependent: :destroy, foreign_key: :manager_id
  has_many :reservations

  ## -------------------- Validations --------------------- ##

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true, uniqueness: { case_sensitive: false }, email: true

  ## --------------------- Callbacks ---------------------- ##

  before_validation { self.email = email.downcase }

  ## ------------------- Class Methods -------------------- ##

  # Authenticate user and return User object on success or false
  def self.login(email:, password:)
    find_by(email: email.downcase)&.authenticate(password) || false
  end

  ## ---------------------- Methods ----------------------- ##

  # JWT Payload, required ID for authentication
  # and role can be used consumer device
  def jwt_payload
    {
      id: id,
      role: role
    }
  end
end
