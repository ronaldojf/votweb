json.set! :results do
  json.array!(@surrogates) do |surrogate|
    json.extract! surrogate, :id, :name, :voter_registration
    json.url url_for([:admin, surrogate])
  end
end

json.set! :total, @surrogates.total_count
