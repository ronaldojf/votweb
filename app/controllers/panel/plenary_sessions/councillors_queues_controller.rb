class Panel::PlenarySessions::CouncillorsQueuesController < Panel::PlenarySessions::BaseController

  def update
    @queue = @plenary_session.queues.find(params[:id])
    @queue.with_lock do
      @queue.add_to_queue(current_user)
    end

    head :no_content
  end
end
