class VotesChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "plenary_session:#{params[:room]}:vote"
  end

  def unsubscribed
    stop_all_streams
  end
end
