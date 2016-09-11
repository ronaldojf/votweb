class CouncillorsQueuesChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "plenary_session:#{params[:room]}:queue"
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    queue = if data['id']
        PlenarySession.find(params[:room]).queues.find(data['id']).update!(data)
      else
        PlenarySession.find(params[:room]).queues.create!(data)
      end
  end
end
