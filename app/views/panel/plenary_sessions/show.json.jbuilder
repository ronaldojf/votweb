json.extract! @plenary_session, :id, :title, :kind

json.set! :polls do
  json.array!(@plenary_session.polls) do |poll|
    json.merge! poll.to_builder.attributes!
  end
end

json.set! :queues do
  json.array! @plenary_session.queues, partial: 'partials/councillors_queues/queue', as: :queue
end
