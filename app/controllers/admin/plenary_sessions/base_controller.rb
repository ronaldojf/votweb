class Admin::PlenarySessions::BaseController < Admin::BaseController
  before_action :set_plenary_session

  private

  def set_plenary_session
    @plenary_session = PlenarySession.find(params[:plenary_session_id])
  end
end
