class Admin::CountdownsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_session_resources
  before_action :set_countdown, only: [:stop]

  def create
    @countdown = Countdown.new(countdown_params)

    if @countdown.save
      render partial: 'partials/countdowns/countdown', locals: { countdown: @countdown }
    else
      render json: @countdown.errors, status: :unprocessable_entity
    end
  end

  def stop
    @countdown.stop_countdown
    head :no_content
  end

  private

  def set_countdown
    @countdown = Countdown.find(params[:id])
  end

  def countdown_params
    params
      .require(:countdown)
      .permit(:description, :duration, :plenary_session_id)
  end

  def authorize_session_resources
    authorize! :manage_session, PlenarySession
  end
end
