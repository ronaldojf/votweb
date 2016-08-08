class Party < ApplicationRecord
  include Utils::Searching

  has_attached_file :logo, styles: { original: '400x400>', thumbnail: '125x125>' }, default_url: ''

  has_many :councillors

  searching :name, :abbreviation

  validates :name, :abbreviation, presence: true
  validates :abbreviation, uniqueness: { case_sensitive: false }
  validates_attachment :logo, presence: true, content_type: { content_type: %w(image/jpeg image/jpg image/png) }, size: { less_than_or_equal_to: 500.kilobytes }
end
