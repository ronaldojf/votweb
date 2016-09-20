class Vote < ApplicationRecord
  acts_as_paranoid

  belongs_to :councillor
  belongs_to :poll

  after_commit :send_sockets

  enum kind: [:approvation, :rejection, :abstention]

  validates :poll, :kind, presence: true

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.poll.plenary_session_id}:vote", self
  end
end
