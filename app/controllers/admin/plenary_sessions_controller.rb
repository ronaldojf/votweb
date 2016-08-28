class Admin::PlenarySessionsController < Admin::BaseController
  before_action :set_plenary_session, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @plenary_sessions = scope_for_ng_table(PlenarySession)
                            .search(params[:filter].try(:[], :search_query).to_s)
                            .by_test(params[:filter].try(:[], :is_test).to_s)
                            .by_kind(params[:filter].try(:[], :kind).to_s)
      end
    end
  end

  def new
    @plenary_session = PlenarySession.new
    @plenary_session.start_at = DateTime.current.next_week(:monday).change(hour: 19, minute: 0, second: 0)
    @plenary_session.end_at = @plenary_session.start_at + 2.5.hours
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
      .permit(:title, :kind, :start_at, :end_at, :is_test)
  end
end
