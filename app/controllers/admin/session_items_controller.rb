class Admin::SessionItemsController < Admin::BaseController
  before_action :set_session_item, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @session_items = scope_for_ng_table(SessionItem)
                            .includes(:author)
                            .search(params[:filter].try(:[], :search_query).to_s)
                            .by_acceptance(params[:filter].try(:[], :acceptance).to_s)
      end
    end
  end

  def new
    @session_item = SessionItem.new
  end

  def create
    @session_item = SessionItem.new(session_item_params)
    @session_item.save
    respond_with :admin, @session_item
  end

  def update
    @session_item.update(session_item_params)
    respond_with :admin, @session_item
  end

  def destroy
    @session_item.destroy
    respond_with @session_item, location: -> { admin_session_items_path }
  end

  private

  def set_session_item
    @session_item = SessionItem.find(params[:id])
  end

  def session_item_params
    params
      .require(:session_item)
      .permit(:title, :councillor_id, :acceptance)
  end
end
