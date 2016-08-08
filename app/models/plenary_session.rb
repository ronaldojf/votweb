class PlenarySession < ApplicationRecord
  include Utils::Searching
  acts_as_paranoid

  searching :title

  validates :title, :start_at, :end_at, presence: true
  validates :start_at, date: { allow_blank: true }
  validates :end_at, date: { after: :start_at, allow_blank: true }
end
