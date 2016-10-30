class Public::HomeController < Public::BaseController
  def index
    @plenary_sessions = PlenarySession.start_or_end_today
  end
end
