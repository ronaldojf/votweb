class CountdownsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "plenary_session:#{params[:room]}:countdown"
  end

  def unsubscribed
    stop_all_streams
  end
end
