class PollsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "plenary_session:#{params[:room]}:poll"
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    poll = if data['id']
        PlenarySession.find(params[:room]).polls.find(data['id']).update!(data)
      else
        PlenarySession.find(params[:room]).polls.create!(data)
      end
  end
end
