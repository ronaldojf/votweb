json.set! :results do
  json.array!(@plenary_sessions) do |plenary_session|
    json.extract! plenary_session, :id, :title, :start_at, :end_at
    json.url url_for([:admin, plenary_session])
  end
end

json.set! :total, @plenary_sessions.total_count
