class Countdown < ApplicationRecord
  include CountdownHelpers

  belongs_to :plenary_session

  after_commit :send_sockets

  validates :plenary_session, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def to_builder
    Jbuilder.new do |json|
      json.extract! self, :id, :plenary_session_id, :description, :countdown, :duration, :created_at
    end
  end

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.plenary_session_id}:countdown", self.to_builder.attributes!
  end
end
