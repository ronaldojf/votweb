class Public::PlenarySessionsController < Public::BaseController
  def show
    @plenary_session = PlenarySession
                        .start_or_end_today
                        .find(params[:id])
  end
end
