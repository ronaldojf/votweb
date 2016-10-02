json.extract! poll, :id, :process, :session_item_id, :description, :duration, :created_at, :deleted_at

json.set! :votes do
  json.array!(poll.votes) do |vote|
    json.extract! vote, :councillor_id, :kind
  end
end
