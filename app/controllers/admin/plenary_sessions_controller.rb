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

  def show
    @members = @plenary_session.members
                  .left_joins(councillor: :party)
                  .includes(councillor: :party)
                  .order('councillors.name ASC')

    @items = @plenary_session.items
                  .includes(:author)
                  .order(:title)
  end

  def new
    @plenary_session = PlenarySession.new
    @plenary_session.start_at = DateTime.current.next_week(:monday).change(hour: 19, minute: 0, second: 0)

    last_president_id = SessionMember.where(is_president: true).last.try(:councillor_id)
    Councillor.active.holder.each do |councillor|
      @plenary_session.members.build councillor: councillor, is_president: councillor.id == last_president_id
    end
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
    result = params
              .require(:plenary_session)
              .permit(
                :title, :kind, :start_at, :is_test, item_ids: [],
                members_attributes: [:id, :councillor_id, :is_president, :_destroy],
              )

    result[:item_ids] ||= []
    result
  end
end
