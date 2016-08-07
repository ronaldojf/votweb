json.set! :results do
  json.array!(@parties) do |party|
    json.extract! party, :id, :name, :abbreviation

    json.logo party.logo(:thumbnail)

    json.url url_for([:admin, party])
  end
end

json.set! :total, @parties.total_count
