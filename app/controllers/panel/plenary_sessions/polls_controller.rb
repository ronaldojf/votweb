class Panel::PlenarySessions::PollsController < Panel::PlenarySessions::BaseController

  def update
    @poll = @plenary_session.polls.find(params[:id])
    @poll.add_vote_for(current_user, params[:vote_type])
    head :no_content
  end
end
