json.extract! @plenary_session, :id, :title, :kind, :start_at, :end_at, :is_test, :created_at, :updated_at

json.set! :members do
  json.array!(@members) do |member|
    json.extract! member, :id, :is_present, :is_president, :created_at, :updated_at

    json.set! :councillor do
      json.extract! member.councillor, :id, :name
    end
  end
end