module NgTableHelper
  def scope_for_ng_table(model)
    result = model
      .page(params[:page])
      .per(params[:count])

    if params[:sorting].try(:keys).try(:any?)
      result = result.reorder(clean_sorting(params[:sorting]))
    end

    store_params_on_session(params)
    result
  end

  private

  def store_params_on_session(params)
    store_controller_config :sorting, params[:sorting]
    store_controller_config :page, params[:page]
    store_controller_config :count, params[:count]
    puts params[:filter].inspect
    store_controller_config :filter, params[:filter]
  end

  def clean_sorting(sort_hash)
    params[:sorting].collect do |k,v|
      [k.to_s.match(/[A-Za-z._]+/)[0], v.to_s.upcase == 'ASC' ? 'ASC' : 'DESC'].join(' ')
    end.first
  end
end