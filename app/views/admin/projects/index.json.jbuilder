json.set! :results do
  json.array!(@projects) do |project|
    json.extract! project, :id, :title
    json.author project.author.name
    json.url url_for([:admin, project])
  end
end

json.set! :total, @projects.total_count
