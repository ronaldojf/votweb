class Panel::PlenarySessions::SubscriptionsController < Panel::PlenarySessions::BaseController
  before_action :set_subscription, only: [:destroy]

  def create
    @subscription = subscription_scope.build(subscription_params)

    if @subscription.save
      render partial: 'partials/subscriptions/subscription', locals: { subscription: @subscription }
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    head :no_content
  end

  private

  def subscription_scope
    @plenary_session.subscriptions.where(councillor_id: current_user.id)
  end

  def set_subscription
    @subscription = subscription_scope.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:kind)
  end
end
