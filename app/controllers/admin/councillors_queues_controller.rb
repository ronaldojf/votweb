class Admin::CouncillorsQueuesController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_session_resources
  before_action :set_queue, only: [:stop]

  def create
    @queue = CouncillorsQueue.new(councillors_queue_params)

    if @queue.save
      render partial: 'partials/councillors_queues/queue', locals: { queue: @queue }
    else
      render json: @queue.errors, status: :unprocessable_entity
    end
  end

  def stop
    @queue.stop_countdown
    head :no_content
  end

  private

  def set_queue
    @queue = CouncillorsQueue.find(params[:id])
  end

  def councillors_queue_params
    params
      .require(:councillors_queue)
      .permit(:plenary_session_id, :kind, :description, :duration, :override_attendance)
  end

  def authorize_session_resources
    authorize! :manage_session, PlenarySession
  end
end
