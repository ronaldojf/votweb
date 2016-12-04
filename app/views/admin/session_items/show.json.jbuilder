json.extract! @session_item, :id, :title, :abstract, :acceptance, :created_at, :updated_at

json.set! :author do
  if @session_item.author.present?
    json.extract! @session_item.author, :id, :name
  else
    json.name I18n.t('miscellaneous.session_item.no_author')
  end
end

json.set! :session do
  if @session_item.session.present?
    json.extract! @session_item.session, :id, :title
  end
end
