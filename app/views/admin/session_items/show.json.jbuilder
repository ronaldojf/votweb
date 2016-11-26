json.extract! @session_item, :id, :title, :abstract, :acceptance, :created_at, :updated_at

json.set! :author do
  json.extract! @session_item.author, :id, :name
end
