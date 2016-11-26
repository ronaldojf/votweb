class Panel::PlenarySessions::BaseController < Panel::BaseController
  before_action :set_plenary_session

  protected

  def set_plenary_session
    @plenary_session = PlenarySession
                        .starts_today
                        .has_member(current_user)
                        .find(params[:plenary_session_id])
  end
end
