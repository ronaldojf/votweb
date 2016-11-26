class Public::PlenarySessionsController < Public::BaseController
  def show
    @plenary_session = PlenarySession
                        .starts_today
                        .find(params[:id])

    @members = @plenary_session.members
                  .left_joins(councillor: :party)
                  .includes(councillor: :party)
                  .order('councillors.name ASC')
  end
end
