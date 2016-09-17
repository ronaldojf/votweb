class CouncillorsQueue < ApplicationRecord
  include Countdown

  belongs_to :plenary_session

  after_commit :send_sockets

  validates :plenary_session, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def add_to_queue(councillor)
    councillor_id = (councillor.try(:id) || councillor).to_i

    if councillor_id > 0 && self.councillors_ids.exclude?(councillor_id)
      self.councillors_ids << councillor_id
      self.save
    end
  end

  def councillors
    councillors_order_map = self.councillors_ids.map.with_index { |id, index| [id, index] }.to_h
    councillors = Councillor.where(id: self.councillors_ids).to_a
    councillors.sort { |first, second| councillors_order_map[first.id] <=> councillors_order_map[second.id] }
  end

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.plenary_session_id}:queue", self
  end
end
