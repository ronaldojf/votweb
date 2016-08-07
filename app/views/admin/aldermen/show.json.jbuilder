json.extract! @alderman, :id, :name, :voter_registration, :gender, :avatar, :created_at, :updated_at

json.set! :party do
  json.extract! @alderman.party, :id, :name, :abbreviation, :logo
end
