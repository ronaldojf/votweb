json.set! :results do
  json.array!(@roles) do |role|
    json.extract! role, :id, :description
    json.url url_for([:admin, role])
  end
end

json.set! :total, @roles.total_count
