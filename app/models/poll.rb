class Poll < ApplicationRecord
  include CountdownHelpers
  acts_as_paranoid

  belongs_to :plenary_session
  has_many :votes

  after_commit :send_sockets

  enum process: [:symbolic, :named, :secret]

  validates :process, :plenary_session, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def add_vote_for(councillor, vote_type)
    councillor_id = councillor.try(:id) || councillor
    type = Vote.kinds[vote_type] || vote_type

    if self.open? && type.present? && !self.votes.where(councillor_id: councillor_id).exists?
      self.votes.create councillor_id: (self.secret? ? nil : councillor_id), kind: type
    end
  end

  def to_builder
    Jbuilder.new do |json|
      json.extract! self, :id, :process, :plenary_session_id, :description, :countdown, :duration, :created_at, :deleted_at
    end
  end

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.plenary_session_id}:poll", self.to_builder.attributes!
  end
end
