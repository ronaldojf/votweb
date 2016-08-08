json.set! :results do
  json.array!(@holds) do |hold|
    json.extract! hold, :id, :reference_id
    json.url url_for([:admin, hold])
  end
end

json.set! :total, @holds.total_count
