json.merge! poll.to_builder.attributes!

json.set! :votes do
  json.array!(poll.votes) do |vote|
    json.merge! vote.to_builder.attributes!
  end
end
