class Vote < ApplicationRecord
  acts_as_paranoid

  belongs_to :councillor
  belongs_to :poll

  after_commit :send_sockets

  enum kind: [:approvation, :rejection, :abstention]

  validates :poll, :kind, presence: true

  def to_builder
    Jbuilder.new do |json|
      json.extract! self, :councillor_id, :poll_id, :kind
    end
  end

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.poll.plenary_session_id}:vote", self.to_builder.attributes!
  end
end
