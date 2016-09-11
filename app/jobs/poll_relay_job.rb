class PollRelayJob < ApplicationJob
  def perform(poll)
    ActionCable.server.broadcast "plenary_session:#{poll.plenary_session_id}:poll", poll
  end
end
