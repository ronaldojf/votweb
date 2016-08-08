class Surrogate < ApplicationRecord
  include Utils::Searching

  searching :name, :voter_registration

  validates :name, :voter_registration, presence: true
  validates :voter_registration, uniqueness: true
end
