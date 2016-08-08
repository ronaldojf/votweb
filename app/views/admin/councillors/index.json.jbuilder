json.set! :results do
  json.array!(@councillors) do |councillor|
    json.extract! councillor, :id, :name, :voter_registration, :gender, :avatar

    json.set! :party do
      json.extract! councillor.party, :id, :name, :abbreviation
    end

    json.url url_for([:admin, councillor])
  end
end

json.set! :total, @councillors.total_count
