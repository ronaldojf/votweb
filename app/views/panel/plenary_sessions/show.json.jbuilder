json.extract! @plenary_session, :id, :title, :kind

json.set! :polls do
  json.array!(@plenary_session.polls) do |poll|
    json.extract! poll, :id, :process, :duration, :created_at
  end
end

json.set! :queues do
  json.array!(@plenary_session.queues) do |queue|
    json.extract! queue, :id, :duration, :created_at
  end
end
