class Admin::PlenarySessionsController < Admin::BaseController
  before_action :set_plenary_session, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @plenary_sessions = scope_for_ng_table(PlenarySession)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @plenary_session = PlenarySession.new
  end

  def create
    @plenary_session = PlenarySession.new(plenary_session_params)
    @plenary_session.save
    respond_with :admin, @plenary_session
  end

  def update
    @plenary_session.update(plenary_session_params)
    respond_with :admin, @plenary_session
  end

  def destroy
    @plenary_session.destroy
    respond_with @plenary_session, location: -> { admin_plenary_sessions_path }
  end

  private

  def set_plenary_session
    @plenary_session = PlenarySession.find(params[:id])
  end

  def plenary_session_params
    params
      .require(:plenary_session)
      .permit(:title, :start_at, :end_at)
  end
end
