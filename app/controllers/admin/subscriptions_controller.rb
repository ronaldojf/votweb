class Admin::SubscriptionsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :authorize_session_resources
  before_action :set_subscription, only: [:update]

  def update
    if @subscription.update(subscription_params)
      head :no_content
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:is_done)
  end

  def authorize_session_resources
    authorize! :manage_session, PlenarySession
  end
end
