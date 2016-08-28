class Poll < ApplicationRecord
  acts_as_paranoid

  belongs_to :plenary_session
  belongs_to :session_item
  has_many :votes

  enum process: [:symbolic, :named, :secret]

  validates :process, :plenary_session, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def duration
    super.try(:seconds) || super
  end
end
