class Poll < ApplicationRecord
  include Countdown
  acts_as_paranoid

  belongs_to :plenary_session
  belongs_to :session_item
  has_many :votes

  after_commit :send_sockets

  enum process: [:symbolic, :named, :secret]

  validates :process, :plenary_session, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.plenary_session_id}:poll", self
  end
end
