json.extract! @role, :id, :description, :created_at, :updated_at

json.set! :permissions do
  json.array!(@role.permissions) do |permission|
    json.extract! permission, :id, :subject, :actions
  end
end
