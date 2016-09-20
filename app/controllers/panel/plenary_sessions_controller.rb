class Panel::PlenarySessionsController < Panel::BaseController
  def show
    @plenary_session = PlenarySession
                        .start_or_end_today
                        .has_member(current_user)
                        .includes(:polls, :queues)
                        .find(params[:id])
  end
end
