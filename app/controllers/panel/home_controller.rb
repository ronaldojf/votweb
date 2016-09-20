class Panel::HomeController < Panel::BaseController
  def index
    @plenary_sessions = PlenarySession.start_or_end_today.has_member(current_user)
  end
end
