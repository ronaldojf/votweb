class Admin::SurrogatesController < Admin::BaseController
  before_action :set_surrogate, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @surrogates = scope_for_ng_table(Surrogate)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @surrogate = Surrogate.new
  end

  def create
    @surrogate = Surrogate.new(surrogate_params)
    @surrogate.save
    respond_with :admin, @surrogate
  end

  def update
    @surrogate.update(surrogate_params)
    respond_with :admin, @surrogate
  end

  def destroy
    @surrogate.destroy
    respond_with @surrogate, location: -> { admin_surrogates_path }
  end

  private

  def set_surrogate
    @surrogate = Surrogate.find(params[:id])
  end

  def surrogate_params
    params
      .require(:surrogate)
      .permit(:name, :voter_registration)
  end
end
