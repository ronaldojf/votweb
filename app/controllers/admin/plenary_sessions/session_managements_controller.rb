class Admin::PlenarySessions::SessionManagementsController < Admin::PlenarySessions::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_session_resources

  private

  def authorize_session_resources
    authorize! :manage_session, PlenarySession
  end
end
