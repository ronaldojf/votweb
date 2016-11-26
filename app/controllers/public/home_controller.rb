class Public::HomeController < Public::BaseController
  def index
    @plenary_sessions = PlenarySession.starts_today
  end
end
