json.extract! @councillor, :id, :name, :username, :is_active, :is_holder, :created_at, :updated_at

json.set! :party do
  json.extract! @councillor.party, :id, :name, :abbreviation, :logo
end
