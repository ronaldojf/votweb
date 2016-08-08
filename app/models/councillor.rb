class Councillor < ApplicationRecord
  include Utils::Searching
  acts_as_paranoid

  has_attached_file :avatar, styles: { big: '1600x1600>', medium: '400x400>', thumbnail: '125x125>' }, default_url: ''

  belongs_to :party

  searching :name, :voter_registration

  scope :by_gender, -> (gender) {
    where(gender: genders[gender]) if gender.present?
  }

  scope :by_party, -> (party) {
    where(party_id: party.try(:id) || party) if party.present?
  }

  enum gender: [:unspecified, :male, :female]

  validates :name, :gender, :party, :voter_registration, presence: true
  validates :voter_registration, uniqueness: true
  validates_attachment :avatar, presence: true, content_type: { content_type: %w(image/jpeg image/jpg image/png) }, size: { less_than_or_equal_to: 5.megabytes }
end
