class Panel::HomeController < Panel::BaseController
  def index
    @plenary_sessions = PlenarySession.starts_today_or_yesterday.has_member(current_user)
  end
end
