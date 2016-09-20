class Admin::PlenarySessions::SessionManagementsController < Admin::PlenarySessions::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_session_resources

  def check_members_presence
    @plenary_session.check_members_presence
    render json: @plenary_session.members.map { |member| member.slice(:id, :is_present) }
  end

  private

  def authorize_session_resources
    authorize! :manage_session, PlenarySession
  end
end
