class CouncillorsQueueRelayJob < ApplicationJob
  def perform(queue)
    ActionCable.server.broadcast "plenary_session:#{queue.plenary_session_id}:queue", queue
  end
end
