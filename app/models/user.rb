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
#  role            :integer          default(1), not null
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

  ## ----------------------- Scopes ----------------------- ##
  ## --------------------- Constants ---------------------- ##
  ## ----------------------- Enums ------------------------ ##

  enum role: {
    admin: 0,
    resturant: 1
  }

  ## -------------------- Associations -------------------- ##
  ## -------------------- Validations --------------------- ##

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true, uniqueness: { case_sensitive: false }, email: true

  ## --------------------- Callbacks ---------------------- ##

  before_validation { self.email = email.downcase }

  ## ------------------- Class Methods -------------------- ##

  def self.login(email:, password:)
    find_by(email: email.downcase)&.authenticate(password) || false
  end

  ## ---------------------- Methods ----------------------- ##
end
