class Permission < ApplicationRecord
  belongs_to :role
  validates :subject, presence: true
end
