class Public::HomeController < Public::BaseController
  def index
    @plenary_sessions = PlenarySession.starts_today_or_yesterday
  end
end
