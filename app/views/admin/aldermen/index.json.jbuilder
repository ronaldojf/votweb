json.set! :results do
  json.array!(@aldermen) do |alderman|
    json.extract! alderman, :id, :name, :voter_registration, :gender, :avatar

    json.set! :party do
      json.extract! alderman.party, :id, :name, :abbreviation
    end

    json.url url_for([:admin, alderman])
  end
end

json.set! :total, @aldermen.total_count
