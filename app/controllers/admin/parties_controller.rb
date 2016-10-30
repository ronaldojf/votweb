class Admin::PartiesController < Admin::BaseController
  before_action :set_party, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @parties = scope_for_ng_table(Party)
                    .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @party = Party.new
  end

  def create
    @party = Party.new(party_params)
    @party.save
    respond_with :admin, @party
  end

  def update
    @party.update(party_params)
    respond_with :admin, @party
  end

  def destroy
    if @party.councillors.exists?
      redirect_to admin_party_path(@party), alert: I18n.t('errors.custom_messages.cant_delete_party_with_councillors')
    else
      @party.destroy
      respond_with @party, location: -> { admin_parties_path }
    end
  end

  private

  def set_party
    @party = Party.find(params[:id])
  end

  def party_params
    params
      .require(:party)
      .permit(:name, :abbreviation)
  end
end
