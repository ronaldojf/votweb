json.set! :results do
  json.array!(@administrators) do |administrator|
    json.extract! administrator, :id, :name, :email, :main
    json.url url_for([:admin, administrator])
  end
end

json.set! :total, @administrators.total_count
