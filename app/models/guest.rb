# frozen_string_literal: true

# == Schema Information
#
# Table name: guests
#
#  id         :bigint(8)        not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  phone      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_guests_on_email  (email)
#  index_guests_on_phone  (phone)
#

class Guest < ApplicationRecord
  ## -------------------- Requirements -------------------- ##
  ## ----------------------- Scopes ----------------------- ##
  ## --------------------- Constants ---------------------- ##
  ## ----------------------- Enums ------------------------ ##
  ## -------------------- Associations -------------------- ##

  has_many :reservations, dependent: :destroy
  has_many :guests,       through: :reservations

  ## -------------------- Validations --------------------- ##

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true, email: true
  validates :phone,      presence: true

  ## --------------------- Callbacks ---------------------- ##
  ## ------------------- Class Methods -------------------- ##
  ## ---------------------- Methods ----------------------- ##
end
