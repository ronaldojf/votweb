class Admin::CouncillorsController < Admin::BaseController
  before_action :set_councillor, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @councillors = scope_for_ng_table(Councillor)
                      .includes(:party)
                      .search(params[:filter].try(:[], :search_query).to_s)
                      .by_gender(params[:filter].try(:[], :gender).to_s)
                      .by_party(params[:filter].try(:[], :party_id).to_s)
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

  def destroy
    @councillor.destroy
    respond_with @councillor, location: -> { admin_councillors_path }
  end

  private

  def set_councillor
    @councillor = Councillor.find(params[:id])
  end

  def councillor_params
    params
      .require(:councillor)
      .permit(:name, :voter_registration, :gender, :party_id, :avatar)
  end
end
