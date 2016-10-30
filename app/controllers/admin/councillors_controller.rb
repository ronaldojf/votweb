class Admin::CouncillorsController < Admin::BaseController
  before_action :set_councillor, only: [:show, :edit, :update]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @councillors = scope_for_ng_table(Councillor)
                      .includes(:party)
                      .search(params[:filter].try(:[], :search_query).to_s)
                      .by_party(params[:filter].try(:[], :party_id).to_s)
                      .by_active(params[:filter].try(:[], :is_active).to_s)
                      .by_holder(params[:filter].try(:[], :is_holder).to_s)
      end
    end
  end

  def new
    @councillor = Councillor.new
  end

  def create
    @councillor = Councillor.new(councillor_params)
    @councillor.save
    respond_with :admin, @councillor
  end

  def update
    @councillor.update(councillor_params)
    respond_with :admin, @councillor
  end

  private

  def set_councillor
    @councillor = Councillor.find(params[:id])
  end

  def councillor_params
    result = params
      .require(:councillor)
      .permit(:name, :username, :password, :password_confirmation, :party_id, :is_active, :is_holder)

      if result[:password].blank?
        result.delete(:password)
        result.delete(:password_confirmation)
      end

    result
  end
end
