class SessionMember < ApplicationRecord
  acts_as_paranoid

  belongs_to :plenary_session
  belongs_to :councillor

  validates :councillor, presence: true
end
