class Admin::AldermenController < Admin::BaseController
  before_action :set_alderman, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @aldermen = scope_for_ng_table(Alderman)
                      .includes(:party)
                      .search(params[:filter].try(:[], :search_query).to_s)
                      .by_gender(params[:filter].try(:[], :gender).to_s)
                      .by_party(params[:filter].try(:[], :party_id).to_s)
      end
    end
  end

  def new
    @alderman = Alderman.new
  end

  def create
    @alderman = Alderman.new(alderman_params)
    @alderman.save
    respond_with :admin, @alderman
  end

  def update
    @alderman.update(alderman_params)
    respond_with :admin, @alderman
  end

  def destroy
    @alderman.destroy
    respond_with @alderman, location: -> { admin_aldermen_path }
  end

  private

  def set_alderman
    @alderman = Alderman.find(params[:id])
  end

  def alderman_params
    params
      .require(:alderman)
      .permit(:name, :voter_registration, :gender, :party_id, :avatar)
  end
end
