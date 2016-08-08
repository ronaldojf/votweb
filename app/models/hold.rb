class Hold < ApplicationRecord
  include Utils::Searching

  searching :reference_id

  validates :reference_id, presence: true, uniqueness: { case_sensitive: false }
end
