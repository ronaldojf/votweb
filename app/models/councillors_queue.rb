class CouncillorsQueue < ApplicationRecord
  include Countdown

  belongs_to :plenary_session

  after_commit :send_sockets

  enum kind: [:normal, :attendance]

  validates :plenary_session, :duration, :kind, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def add_to_queue(councillor)
    councillor_id = (councillor.try(:id) || councillor).to_i

    if self.open? && councillor_id > 0 && self.councillors_ids.exclude?(councillor_id)
      self.councillors_ids << councillor_id
      self.save
    end
  end

  def councillors
    councillors_order_map = self.councillors_ids.map.with_index { |id, index| [id, index] }.to_h
    councillors = Councillor.where(id: self.councillors_ids).to_a
    councillors.sort { |first, second| councillors_order_map[first.id] <=> councillors_order_map[second.id] }
  end

  def to_builder
    Jbuilder.new do |json|
      json.extract! self, :id, :kind, :description, :countdown, :duration, :councillors_ids, :created_at
    end
  end

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.plenary_session_id}:queue", self.to_builder.attributes!
  end
end
