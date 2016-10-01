class Party < ApplicationRecord
  include Utils::Searching

  has_many :councillors

  searching :name, :abbreviation

  validates :name, :abbreviation, presence: true
  validates :abbreviation, uniqueness: { case_sensitive: false }
end
