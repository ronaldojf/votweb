json.extract! @plenary_session, :id, :title, :kind, :start_at, :end_at, :is_test, :created_at, :updated_at

json.set! :members do
  json.array!(@members) do |member|
    json.extract! member, :id, :is_present, :is_president, :created_at, :updated_at

    json.set! :councillor do
      json.extract! member.councillor, :id, :name

      json.set! :party do
        json.extract! member.councillor.party, :id, :abbreviation
      end
    end
  end
end

json.set! :items do
  json.array!(@items) do |item|
    json.extract! item, :id, :title, :acceptance

    json.set! :author do
      json.extract! item.author, :id, :name
    end
  end
end

json.set! :polls do
  json.array! @plenary_session.polls, partial: 'partials/polls/poll', as: :poll
end

json.set! :queues do
  json.array! @plenary_session.queues, partial: 'partials/councillors_queues/queue', as: :queue
end
