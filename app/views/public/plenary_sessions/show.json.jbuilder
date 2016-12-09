json.extract! @plenary_session, :id, :title, :kind

json.set! :members do
  json.array!(@members) do |member|
    json.extract! member, :id, :is_present, :is_president

    json.set! :councillor do
      json.extract! member.councillor, :id, :name

      json.set! :party do
        json.extract! member.councillor.party, :id, :abbreviation
      end
    end
  end
end

json.set! :polls do
  json.array! @plenary_session.polls.includes(:votes), partial: 'partials/polls/poll', as: :poll
end

json.set! :queues do
  json.array! @plenary_session.queues, partial: 'partials/councillors_queues/queue', as: :queue
end

json.set! :countdowns do
  json.array! @plenary_session.countdowns, partial: 'partials/countdowns/countdown', as: :countdown
end

if respond_to?(:current_councillor) && current_councillor.present?
  json.set! :subscriptions do
    json.array! @plenary_session.subscriptions.where(councillor_id: current_councillor.id), partial: 'partials/subscriptions/subscription', as: :subscription
  end
end
