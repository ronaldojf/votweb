class Councillor < ApplicationRecord
  include Utils::Searching
  devise :database_authenticatable, :validatable, authentication_keys: [:username]
  acts_as_paranoid

  belongs_to :party

  searching :name, :username

  scope :active, -> { where(is_active: true) }
  scope :holder, -> { where(is_holder: true) }
  scope :surrogate, -> { where(is_holder: false) }

  scope :by_party, -> (party) {
    where(party_id: party.try(:id) || party) if party.present?
  }

  scope :by_active, -> (is_active) {
    where(is_active: is_active.to_s == 'true') if !is_active.nil? && is_active.to_s.present?
  }

  scope :by_holder, -> (is_holder) {
    where(is_holder: is_holder.to_s == 'true') if !is_holder.nil? && is_holder.to_s.present?
  }

  validates :name, :username, :party, presence: true

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
