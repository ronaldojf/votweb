json.extract! @project, :id, :title, :created_at, :updated_at

json.set! :author do
  json.extract! @project.author, :id, :name, :voter_registration
end
