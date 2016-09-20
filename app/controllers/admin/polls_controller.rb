class Admin::PollsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_session_resources
  before_action :set_poll, only: [:stop]

  def create
    @poll = Poll.new(poll_params)

    if @poll.save
      render partial: 'partials/polls/poll', locals: { poll: @poll }
    else
      render json: @poll.errors, status: :unprocessable_entity
    end
  end

  def stop
    @poll.stop_countdown
    head :no_content
  end

  private

  def set_poll
    @poll = Poll.find(params[:id])
  end

  def poll_params
    params
      .require(:poll)
      .permit(:description, :process, :duration, :plenary_session_id, :session_item_id)
  end

  def authorize_session_resources
    authorize! :manage_session, PlenarySession
  end
end
