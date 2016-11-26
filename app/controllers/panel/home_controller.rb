class Panel::HomeController < Panel::BaseController
  def index
    @plenary_sessions = PlenarySession.starts_today.has_member(current_user)
  end
end
