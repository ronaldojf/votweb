class Admin::HoldsController < Admin::BaseController
  before_action :set_hold, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @holds = scope_for_ng_table(Hold)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @hold = Hold.new
  end

  def create
    @hold = Hold.new(hold_params)
    @hold.save
    respond_with :admin, @hold
  end

  def update
    @hold.update(hold_params)
    respond_with :admin, @hold
  end

  def destroy
    @hold.destroy
    respond_with @hold, location: -> { admin_holds_path }
  end

  private

  def set_hold
    @hold = Hold.find(params[:id])
  end

  def hold_params
    params
      .require(:hold)
      .permit(:reference_id)
  end
end
