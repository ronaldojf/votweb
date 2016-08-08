json.extract! @councillor, :id, :name, :voter_registration, :gender, :avatar, :created_at, :updated_at

json.set! :party do
  json.extract! @councillor.party, :id, :name, :abbreviation, :logo
end
