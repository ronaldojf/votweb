class PollsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "plenary_session:#{params[:room]}:poll"
  end

  def unsubscribed
    stop_all_streams
  end
end
