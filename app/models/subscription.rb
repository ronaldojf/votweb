class Subscription < ApplicationRecord
  belongs_to :plenary_session
  belongs_to :councillor

  after_commit :send_sockets

  enum kind: [:expedient, :notice, :explanation]

  validates :kind, :plenary_session, :councillor, presence: true
  validates :kind, uniqueness: { scope: [:plenary_session_id, :councillor_id] }

  def destroy
    super unless self.is_done?
  end

  def to_builder
    Jbuilder.new do |json|
      json.extract! self, :id, :plenary_session_id, :councillor_id, :kind, :is_done, :created_at
      json._destroyed self.destroyed?
    end
  end

  private

  def send_sockets
    ActionCable.server.broadcast "plenary_session:#{self.plenary_session_id}:subscription", self.to_builder.attributes!
  end
end
