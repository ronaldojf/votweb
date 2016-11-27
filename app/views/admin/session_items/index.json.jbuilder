json.set! :results do
  json.array!(@session_items) do |session_item|
    json.extract! session_item, :id, :title, :acceptance
    json.author session_item.author.try(:name) || I18n.t('miscellaneous.session_item.no_author')
    json.url url_for([:admin, session_item])
  end
end

json.set! :total, @session_items.total_count
